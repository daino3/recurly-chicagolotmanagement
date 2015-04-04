var invalid_fields = {};
var error_fields = {
  first_name: 'First name',
  last_name: 'Last name',
  email: 'Email address',
  number: 'Credit Card number',
  postal_code: 'Postal Code',
  month: 'Expiration Month',
  year: 'Expiration Year',
  cvv: 'CVV',
  address: 'Street address',
  city: 'City'
};

// Configure stripe.js
Stripe.setPublishableKey('pk_test_T1fudZUAy97QWvSz9Fo5b94u');

function stripeResponseHandler (status, response) {

  var formData = JSON.parse(JSON.stringify($('form').serializeArray()))
  var stripeAccount = {'name': "account[][stripe_id]", 'value': response.id}
  var stripePlan = {'name': "subscription_id", 'value': $("#plan option:selected").text()}
  var data = formData.concat(stripeAccount, stripePlan)

  // valid test data
  // valid card ='4242424242424242'
  // valid cvv =

  if (status == "200"){
    $.ajax({
      type: "POST",
      url: '/api/subscriptions/new',
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
  console.log(data);
  $('form').addClass('form__success');

  $('.confirmation').addClass('confirmation__show');
  $('.confirmation-messaging').addClass('animate');
  $('[role="form-errors"]').addClass("form-errors__hidden")
}

// A simple error handling function to expose errors to the customer
function renderErrors (response) {
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
  $('form').on('submit', function (event) {
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

  // Identity card type
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

  $("[role='quantity']").text($(".property").length);
  updateGrandTotal();
})

function updateGrandTotal () {
  var pricing = $("[role='plan-pricing']").text();
  var quant = $("[role='quantity']").text();
  $("[role='grand-total']").html(parseInt(quant) * parseInt(pricing));
}
