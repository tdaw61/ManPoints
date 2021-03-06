function addPhoto(input, id) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            ele= $(id);
            ele.find("#img_prev")
                .attr('src', e.target.result)
                .width(75)
                .height(90);
            ele.find("#img_prev").show();
            ele.find('.post-extras').show();
        };

        reader.readAsDataURL(input.files[0]);
    }
}

function removePhoto(id){

    if(id)
        ele = $('#userpost_'+id);
    else
        ele = $('#userpost-form');
    ele.find("#img_prev").hide();
    ele.find('.post-extras').hide();
    ele.find('#img_prev').attr('src', '');
    ele.find('#lefile').val("");
}
