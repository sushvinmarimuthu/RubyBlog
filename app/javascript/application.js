// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

$(document).ready(function(){
    if ($("body").hasClass("postsshow")){
        const element = document.querySelector(".post_read");
        $.ajax({
            url: element.classList[1]+"/user_post_read_status",
            type: "post",
            data: "",
            success: function(data) {
                const body = data.substring(data.indexOf("<body>"), data.indexOf("</body>"));
                $('body').html(body);
            },
            error: function(data) {}
        })
    }
    if ($("body").hasClass("postsindex")){
        const element = document.querySelector(".postsindex");
        let url;
        if($.isNumeric(element.classList[1])){
            url = '/topics/'+ element.classList[1] +'/posts/'
        }else{
            url = '/posts/';
        }
        $(document).on('submit','#new_post_form',function(e){
            e.preventDefault();
            const post_form = new FormData($('#new_post_form')[0]);
            $('#postCreationModal').modal('hide');
            if($("#spinner-div").hasClass('d-none')){
                $("#spinner-div").removeClass('d-none')
            }
            $.ajax({
                type : 'post',
                url : url,
                data : post_form,
                cache : false,
                processData: false,
                contentType: false,
                success : function(response) {
                    alert("Post created Successfully");
                    $("#new_post_form")[0].reset();
                    const body = response.substring(response.indexOf("<body>"), response.indexOf("</body>"));
                    $('body').html(body);
                },
                complete: function () {
                    if(!$("#spinner-div").hasClass('d-none')){
                        $("#spinner-div").addClass('d-none')
                    }
                },
                error: function (response) {
                    console.log(response.responseText);
                    if(response.responseText === "[\"Title is too long (maximum is 20 characters)\"]"){
                        alert("Title should not have more than 20 characters.");
                    }
                },
            });
        });
    }
});
