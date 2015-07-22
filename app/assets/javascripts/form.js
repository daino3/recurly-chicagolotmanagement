var SELECTORS = {
 'addProperty': "[role='add-property']",
 'discount': "[role='discount']",
 'promoCodeHidden': "[role='promo-code-hidden']",
 'formErrors': "[role='form-errors']",
 'grantTotal': "[role='grand-total']",
 'pricing': "[role='plan-pricing']",
 'promoCode': "[role='promo-code']",
 'quantity': "[role='quantity']",
 'removeProperty': "[role='remove-property']",
 'subscriptionPrice': "[role='subscription-price']"
};

function stripeResponseHandler (status, response) {
  var formData = JSON.parse(JSON.stringify($('#subscription-form').serializeArray()));
  var stripeAccount = {'name': "account[][stripe_token]", 'value': response.id};
  var stripePlan = {'name': "subscription_type", 'value': $("#plan option:selected").text()};
  var data = formData.concat(stripeAccount, stripePlan);

  // valid test data
  // valid card ='4000000000000077'
  // valid cvv =

  if (status == "200"){
    $.ajax({
      type: "POST",
      url: '/subscriptions/create',
      data: data,
      success: subscriptionCreated(data),
      dataType: 'json'
    });
  } else {
    renderErrors(response);
  }
  return false
}

function subscriptionCreated(data) {
  $('#subscription-form').addClass('form__success');

  $('.confirmation').addClass('confirmation__show');
  $('.confirmation-messaging').addClass('animate');
}

// A simple error handling function to expose errors to the customer
function renderErrors(response) {
  var message = response.error.message
  var errors_markup = '<li class="form-errors--invalid-field">' + message + '</li>';

  $('.form-errors ul')
    .empty()
    .append(errors_markup);

  $('[role="form-errors"]').removeClass("form-errors__hidden")

  $('input[type="submit"]').prop('disabled', false);
}


$(document).ready(function() {
  // On form submit, we stop submission to go get the token
  $('#subscription-form').on('submit', function (event) {
    event.preventDefault();
    var $form = $(this);

    // Disable the submit button
    $('#subscribe').prop('disabled', true);

    Stripe.card.createToken($form, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
  });

  $("select.plan").change(function() {
    var index = $(this).val();
    var newPlan = $("option[value="+index+"]").text();
    window.currentPlan = newPlan;

    var pricing = window.StripePricing[newPlan];
    $("[role='subscription-price']").html(pricing);
    $("[role='plan-pricing']").html(pricing);
    updateGrandTotal();
  })

  // Identify card type
  $("#number").on('blur', function(event) {
    var cardNumber = $("#number").val()
    var cardIsValid = $.payment.validateCardNumber(cardNumber)

    if(cardIsValid) {
      $(".form-input__number").removeClass('form-input__error');
    }
    else {
      $(".form-input__number").addClass('form-input__error');
    }
  });
});

$(document).on('keyup', "[role='promo-code']",
  _.debounce(function(){
    var $ele = $(this);
    var code = $ele.val()
    var couponData = {"coupon_id": code}
    $.get('/valid_promo', couponData, function(response){
      if (response.status == 200) {
        $ele.addClass('valid-promo');
        $ele.removeClass('form-input__error');

        $(SELECTORS.discount).text(calcDiscount(response.discount));
        $(SELECTORS.promoCodeHidden).val(code);
        updateGrandTotal();
      } else {
        $ele.addClass('form-input__error');
        $ele.removeClass('valid-promo');
      };
    });
  }, 300)
);

$(document).on('click', "[role='add-property']", function(){
  $list = $('ul.properties');
  var properties = $('.properties').length;
  var data = {"count": properties};
  $.get('add-property', data, function(data) {
    $list.append(data);

    if ($list.children().length > 1) {
      $("[role='remove-property']").removeClass('hidden');
    } else {
      $("[role='remove-property']").addClass('hidden');
    }

    $("[role='quantity']").text($('.property').length);
    updateGrandTotal();
  });
})

$(document).on('click', "[role='remove-property']", function(){
  $list = $('ul.properties');

  $(".property-separator").last().remove();
  $(".property").last().remove();

  if ($list.children().length <= 1) {
    $("[role='remove-property']").addClass('hidden');
  }

  $("[role='quantity']").text($('.property').length);
  updateGrandTotal();
})

function pricing() {
  return parseFloat($(SELECTORS.pricing).text()).toFixed(2);
};

function quantity() {
  return parseFloat($(SELECTORS.quantity).text()).toFixed(2);
};

function discount() {
  return parseFloat($(SELECTORS.discount).text()).toFixed(2);
};

function currentTotal() {
  return totalBeforeDiscount() - discount();
};

function totalBeforeDiscount() {
  return pricing() * quantity();
};

function calcDiscount(percent) {
  return totalBeforeDiscount() * parseFloat(percent).toFixed(2);
};

function updateGrandTotal() {
  $(SELECTORS.grantTotal).html(currentTotal());
  return false;
};
