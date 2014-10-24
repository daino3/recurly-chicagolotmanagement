function showAddons(addons) {
  var source   = $("#addon-template").html()
    , template = Handlebars.compile(source)
    , data = { list: [] };

  $(addons).each(function(idx, value) {
    data.list.push({
      name: value.name,
      code: value.code,
      price: value.price.USD.unit_amount
    });
  });

  $('.addons-container').html(template(data));
}

function showAddonsSummary(addon) {
    

  var source   = $("#addon-summary-template").html()
    , template = Handlebars.compile(source)
    , data = { list: [] };
    
if(addon.quantity != 0) {
 $(addon).each(function(idx, value) {
    data.list.push({
      name: value.name,
      code: value.code,
      quantity: value.quantity,
      price: value.price.USD.unit_amount
    });
  }); 
}
  $('.addons-items-summary').append(template(data));

}

function advancedConfirmation(x) {
    

  var source   = $("#advanced-confirmation-template").html()
    , template = Handlebars.compile(source)
    , data = { list: [] };

    var num = x.number;
    var nu = num.split('');
    var n = nu.slice(-4);  
    var number = n.join('');
    console.log(number);

    
  $(x).each(function(idx, value) {
    data.list.push({
      firstName:value['first-name'],
      lastName: value['last-name'],
      addons: value.addons,
      address: value.address,
      city: value.city,
      state: value.state,
      month: value.month,
      year: value.year,
      zip: value.zip,
      country: value.country,
      number: number
    }); 
  });
    
 //$(addon).each(function(idx, value) {

  //}); 
console.log(data);

  $('.subscription-details-container').append(template(data));

}





