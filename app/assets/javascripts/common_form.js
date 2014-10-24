var invalid_fields = [];
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

// Configure recurly.js
recurly.configure('sc-Hw20ERMh8bzGFiWKO7NvDB');

function create_subscription () {
  var data = {
    "recurly-token": $('input[name="recurly-token"]').val(),
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

//NOTE: made this new function because the subscription_created function was too specific, didn't work for the advanced mobile version.
// if you change 'form' .addClass('form__success') to something more generic, this function can be consolidated.  
function create_subscription_advanced () {
  var data = {
    "recurly-token": $('input[name="recurly-token"]').val(),
    "first-name": $('input[name="first-name"]').val(),
    "last-name": $('input[name="last-name"]').val(),
    "email": $('input[name="email"]').val(),
    "address" : $('input[name="address"]').val(),
    "city" : $('input[name="city"]').val(),
    "state" : $('#state').val(),
    "zip": $('input[name="postal-code"]').val(),
    "number": $('input[name="number"]').val(),
    "month": $('input[name="month"]').val(),
    "year": $('input[name="year"]').val(),
    "addons": $('.addons-items-summary').html(),
    "number": $('input[name="number"]').val()
  };

  $.ajax({
    type: "POST",
    url: '/api/subscriptions/new',
    data: data,
    success: subscription_created_advanced(data),
    dataType: 'json'
  });
}

function create_subscription_onetime() {
  var data = {
    "recurly-token": $('input[name="recurly-token"]').val(),
    "first-name": $('input[name="first-name"]').val(),
    "last-name": $('input[name="last-name"]').val(),
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
    url: '/api/transactions',
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
//this is mostly redundant, see note above.  I just didn't want to touch all the forms, didn't know what else would
//be affected.
function subscription_created_advanced(data) {
  console.log(data);
  $('.hide-form-onsuccess').addClass('form__success');

  $('.confirmation').addClass('confirmation__show');
  $('.confirmation-messaging').addClass('animate');

  advancedConfirmation(data);
}

function clear_errors() {
  while(invalid_fields.length > 0) {
    invalid_fields.pop();
  }
  $('.form-errors--invalid-field').removeClass('form-errors--invalid-field');
}

function check_required_fields() {
  var fields = $('.form-input__required');

  $.each(fields, function(i, field) {
    if($(field).val() == "") {
      invalid_fields.push($(field).attr('data-recurly'));
    }
    else {
      $('.form-input__' + $(field).attr('data-recurly')).removeClass('form-input__error');
    }
  });
}

function paypalError (err) {

    if (err.niceMessage) {
      errors_markup = '<li class="form-errors--invalid-field">' + err.niceMessage + '</li>';
      } else {
        $.each(err.fields, function(i, field) {
          if(typeof invalid_fields[field] == undefined) {
            invalid_fields.push(field);
          }
        });

        var errors_markup = $.map(invalid_fields, function (field) {
          $('.form-input__' + field).addClass('form-input__error');
          return '<li class="form-errors--invalid-field">' + paypal_error_fields[field] || field + '</li>';
        }).join('');
      }

      $('.form-errors').removeClass('form-errors__hidden');
      $('.form-errors ul')
        .empty()
        .append(errors_markup);

      $('input[type="submit"]').prop('disabled', false);
}

// A simple error handling function to expose errors to the customer
function error (err) {

  if (err.niceMessage) {
    errors_markup = '<li class="form-errors--invalid-field">' + err.niceMessage + '</li>';
  } else {
    $.each(err.fields, function(i, field) {
      if(typeof invalid_fields[field] == undefined) {
        invalid_fields.push(field);
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
