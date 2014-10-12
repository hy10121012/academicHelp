/**
 * Created with JetBrains RubyMine.
 * User: yi
 * Date: 14-9-30
 * Time: 上午12:42
 * To change this template use File | Settings | File Templates.
 */

$(document).ready(function () {
    $('#user_country_id, #user_user_type_id').on('change', function () {
        var countryObj =$('#user_country_id');
        var url = 'get_university_by_country';
        if($('#user_user_type_id').val()==2){
            url = 'get_writer_university_by_country';
            $('.taker_only').show()
        }else{
            $('.taker_only').hide()
        }
        $.ajax({
            url: '/'+url,
            type: 'get',
            beforeSend: function (xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            },
            data: {id: countryObj.val()},
            dataType: 'json',
            success: function (data) {
                var newOptions = data;
                var $el = $('#user_university_id');
                $el.html(' ');
                $.each(newOptions, function(key, value) {
                $el.append($("<option></option>")
                .attr("value", value.id).text(value.name));
                });
            }
        });
    }) ;

    $('#user_email').on('blur',function(){
        if( !isValidEmailAddress($(this).val()) ) {
        $('#email_warning').text('邮箱格式不正确')
        }else{
        $('#email_warning').text('');
        }
    });

    $('#register_form').on('submit',function(){
        var pass=true;
        var form  = $(this)
        $('.mandatory').each(function(){
        if ($(this).val()=='' || $(this).val().length==0 || $(this).val()=='undefined' || $(this).val()=='0'|| $(this).val()=='请先选择国家'){
        $(this).css('border','1px solid red')
        pass=false;
        }else{
        $(this).css('border','1px solid #c9cdcd')
        }
    })
    if( !isValidEmailAddress($('#user_email').val()) ) {
        $('#email_warning').text('邮箱格式不正确')
        pass=false;
        }else{
        $('#email_warning').text('');
        }
    if(pass==true){
        $('#warning').text('')
        form.submit()
        }else{
        $('#warning').text("请填写所有信息")
        $('#submit').removeAttr("disabled")
        return false;
        }
    })

    function isValidEmailAddress(emailAddress) {
        var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
    return pattern.test(emailAddress);
    };
})

