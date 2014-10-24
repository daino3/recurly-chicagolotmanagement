$(document).ready(function() {
  // On form submit, we stop submission to go get the token
  $('form').on('submit', function (event) {
    event.preventDefault();

    // Disable the submit button
    $('#subscribe').prop('disabled', true);
    clear_errors();
    check_required_fields()

    var form = this;

    if( $('#subscribe').hasClass('btn-submit') ) {
        // Now we call recurly.token with the form. It goes to Recurly servers
      // to tokenize the credit card information, then injects the token into the
      // data-recurly="token" field above
      recurly.token(form, function (err, token) {
        if (err) {
          error(err);
        } else {
          create_subscription();
        };
      });
    }//end if
    
    else {

      recurly.paypal({ description: 'test' }, function (err, token) {
        if (err) {
          console.log(err);
          // Let's handle any errors using the function below
          paypalError(err);
        } else {
          // set the hidden field above to the token we get back from Recurly
          $('#recurly-token').val(token.id);

          // Now we submit the form!
          form.submit();
        }
      });

    }

    

  });

  




  // Identity card type
  $("#number").on('change', function(event) {
    var card_number = $("#number").val()
      , card_type = recurly.validate.cardType(card_number)
      , card_is_valid = recurly.validate.cardNumber($("#number").val())
      , number_field = $('.customer-fields--card-number .form-input');

    if(card_is_valid) {
      $(number_field).removeClass('form-input__error');
    }
    else {
      $(number_field).addClass('form-input__error');
    }

    if((card_type == 'default') || (card_type == 'unknown')) {
      $('.icon-card').addClass('icon-card__generic');
      $('.icon-card').removeClass('icon-card__visa icon-card__mastercard icon-card__amex icon-card__visa discover');
    }
    else {
      $('.icon-card').removeClass('icon-card__generic');
      $('.icon-card').addClass('icon-card__' + card_type);
    }
  });
});
