/*
 Copyright (c) 2012-2015, Pierre-Olivier Latour
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * The name of Pierre-Olivier Latour may not be used to endorse
 or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PIERRE-OLIVIER LATOUR BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

var ENTER_KEYCODE = 13;

var _timer;
var _pendingReloads = [];
var _reloadingDisabled = 0;

function _showError(message, textStatus, errorThrown) {
    $("#alerts").prepend(tmpl("template-alert", {
                              level: "danger",
                              title: (errorThrown != "" ? errorThrown : textStatus) + ": ",
                              description: message
                              }));

    clearInterval(_timer);
}

function _formatDate(rawDate) {
    var year = rawDate.getFullYear();
    var month = rawDate.getMonth() + 1;
    var date = rawDate.getDate();
    var hour = rawDate.getHours();
    var minute = rawDate.getMinutes();
    var second = rawDate.getSeconds();
    var millisecond = rawDate.getMilliseconds();
    return year + "-" + month + "-" + date + " " + hour + ":" + minute + ":" + second + "." + millisecond;
}

function _disableReloads() {
  _reloadingDisabled += 1;
}

function _enableReloads() {
  _reloadingDisabled -= 1;
  
  if (_pendingReloads.length > 0) {
    _reload(_pendingReloads.shift());
  }
}

function _reload(path) {
    
  if (_reloadingDisabled) {
    if ($.inArray(path, _pendingReloads) < 0) {
      _pendingReloads.push(path);
    }
    return;
  }
  
  _disableReloads();
  $.ajax({
    url: 'list',
    type: 'GET',
    data: {path: path},
    dataType: 'json'
  }).fail(function(jqXHR, textStatus, errorThrown) {
    _showError("Failed retrieving contents of \"" + path + "\"", textStatus, errorThrown);
  }).done(function(data, textStatus, jqXHR) {


    var totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());

    var positionAtBottom = ($(document).height() <= totalheight);

    $("#path").empty();
    $("#path").append('<li class="active">' + _device + '</li>');
    
    // $("#listing").empty();
    for (var i = 0, file; file = data[i]; ++i) {
      file.timeText = _formatDate(new Date(file.timestamp * 1000));
      file.content = file.content.replace(/\n/g, "<br>");
      console.log(file.content);
      $(tmpl("template-listing", file)).data(file).appendTo("#listing");
    }
    
    if (positionAtBottom) {
      $(document).scrollTop($(document).height());  
    }    
  }).always(function() {
    _enableReloads();
  });
}

$(document).ready(function() {
                  
  $("#reload").click(function(event) {
    _reload("/");
  });
  
  _reload("/");

  _timer = setInterval('_reload("/")', 1000); //1000为1秒钟
});
