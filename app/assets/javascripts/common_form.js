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
var paypal_error_fields = {
  first_name: 'First name',
  last_name: 'Last name'
};

// Configure stripe.js
stripe.configure('sc-Hw20ERMh8bzGFiWKO7NvDB');

function create_subscription () {
  var data = {
    "stripe-token": $('input[name="stripe-token"]').val(),
    "first-name": $('input[name="first-name"]').val(),
    "last-name": $('input[name="last-name"]').val(),
    "email": $('input[name="email"]').val(),
    "address" : $('input[name="address"]').val(),
    "city" : $('input[name="city"]').val(),
    "state" : $('#state').val(),
    "zip": $('input[name="postal-code"]').val(),
    "number": $('input[name="number"]').val(),
    "month": $('input[name="month"]').val(),
    "year": $('input[name="year"]').val()
  };

  $.ajax({
    type: "POST",
    url: '/api/subscriptions/new',
    data: data,
    success: subscription_created(data),
    dataType: 'json'
  });
}

function subscription_created(data) {
  console.log(data);
  $('form').addClass('form__success');

  $('.confirmation').addClass('confirmation__show');
  $('.confirmation-messaging').addClass('animate');
}

function clear_errors() {
  invalid_fields = {};
  $('.form-errors--invalid-field').removeClass('form-errors--invalid-field');
}

// A simple error handling function to expose errors to the customer
function error (err) {

  if (err.niceMessage) {
    errors_markup = '<li class="form-errors--invalid-field">' + err.niceMessage + '</li>';
  } else {
    $.each(err.fields, function(i, field) {
      if(typeof invalid_fields[field] === 'undefined') {
        invalid_fields[field] = field;
      }
    });

    var errors_markup = $.map(invalid_fields, function (field) {
      $('.form-input__' + field).addClass('form-input__error');
      return '<li class="form-errors--invalid-field">' + error_fields[field] || field + '</li>';
    }).join('');
  }

  $('.form-errors').removeClass('form-errors__hidden');
  $('.form-errors ul')
    .empty()
    .append(errors_markup);

  $('input[type="submit"]').prop('disabled', false);
}
