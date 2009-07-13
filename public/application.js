$(document).ready(function() {

  // Initialize an array to track picked results
  var picks = []
  
  // Hide all the results and then show only the top result
  // from each search engine
  $('li').hide();
  var lis_1 = $('ul#1 li');
  var lis_2 = $('ul#2 li');
  $(lis_1[0]).show();
  $(lis_2[0]).show();

  // Set up the event handler on the checkboxes to advance
  // the picker and tally the results
  $('.picker').bind('click',pick)

  function pick() {
    // if we haven't finished with the ten results, add the previous result
    // to the picks array, hide the previous result set, and show the next result set
    if (picks.length<9) {
      picks.push(this.value);
      $(lis_1[picks.length-1]).hide();
      $(lis_2[picks.length-1]).hide();
      $(lis_1[picks.length]).show();
      $(lis_2[picks.length]).show();
      
    // If we're on the last result, add it to the picks array,
    // hide the last results and tally up the totals
    } else {
      picks.push(this.value);
      $('ul').hide();
      $('h3').hide();
      tally();
    };
  }
  
  function tally() {
    var percentage;
    var engine;
    
    // Create an array to track picks for google
    var pref = []
    for (var i=0; i < picks.length; i++) {
      if (picks[i] == 1) {
        pref.push(1)
      }
    };
    
    if (pref.length>=5) {
      engine = "Google";
      percentage = pref.length*10;
    } else {
      engine = "Yahoo!";
      percentage = (10-pref.length)*10;
    };
    
    // Result Text
    var r = "";
    r += "<h2>You preferred " + engine + " " + percentage + "% of the time.</h2>";
    r += "<ol>";
    
    for (var i=0; i < picks.length; i++) {
      if (picks[i]==1) {
        r += "<li>Google</li>";
      } else {
        r += "<li>Yahoo!</li>";
      };
    };
    
    r += "</ol>";

    // Inject the result text into the DOM
    $('#results').html(r).show();
  }

});

