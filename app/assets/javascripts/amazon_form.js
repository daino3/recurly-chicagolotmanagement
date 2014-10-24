(function () {

  var payWithAmazon = new PayWithAmazon({
    clientId: 'amzn1.application-oa2-client.127b0a3e68334641a3e4e129f686d140',
    sellerId: 'A35095BGBGQR66',
    button: 'amazon-button',
    wallet: { id: 'amazon-wallet', width: 300 },
    consent: { id: 'amazon-consent', width: 300 },
    addressBook: { id: 'amazon-address-book', width: 300 }
  }).on('change', notify);

  var amazonBillingAgreement;

  $(function () {
    amazonBillingAgreement = $('#amazon-billing-agreement');

    payWithAmazon.on('ready.addressBook', function (event) {
      $('#amazon-button').hide();
    });

    $('form').on('submit', function (event) {
      event.preventDefault();

      if (amazonBillingAgreement.val()) {
        create_subscription();
      } else {
        error({
          niceMessage: 'Please Agree to Billing terms by logging in and paying with Amazon.',
        });
      }
    });
  });

  function notify (status) {
    console && console.log(status);

    if (status.id) {
      clear_errors();
      amazonBillingAgreement.val(status.id);
    }
  }
})();
