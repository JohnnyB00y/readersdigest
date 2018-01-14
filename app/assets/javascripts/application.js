// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.

//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require turbolinks
//= require_tree .


// Initialize all acts-as-taggable-on + select2 tag inputs
$("*[data-taggable='true']").each(function() {
    console.log("Taggable: " + $(this).attr('id') + "; initializing select2");
    $(this).select2({
        tags: true,
        theme: "bootstrap",
        width: "100%",
        tokenSeparators: [','],
        minimumInputLength: 2,
        ajax: {
            url: "/tags",
            dataType: 'json',
            delay: 100,
            data: function (params) {
                console.log("Using AJAX to get tags...");
                console.log("Tag name: " + params.term);
                console.log("Existing tags: " + $(this).val());
                console.log("Taggable type: " + $(this).data("taggable-type"));
                console.log("Tag context: " + $(this).data("context"));
                return {
                    name: params.term,
                    tags_chosen: $(this).val(),
                    taggable_type: $(this).data("taggable-type"),
                    context: $(this).data("context"),
                    page: params.page
                }
            },
            processResults: function (data, params) {
                console.log("Got tags from AJAX: " + JSON.stringify(data, null, '\t'));
                params.page = params.page || 1;
        
                return {
                    results: $.map(data, function (item) {
                        return {
                            text: item.name,
                            // id has to be the tag name, because acts_as_taggable expects it!
                            id: item.name
                        }
                    })
                };
            },
            cache: true
        }
    });
});