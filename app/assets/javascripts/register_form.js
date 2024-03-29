/**
 * Created with JetBrains RubyMine.
 * User: yi
 * Date: 14-9-30
 * Time: 上午12:42
 * To change this template use File | Settings | File Templates.
 */

$(document).ready(function () {
    function isValidEmailAddress(emailAddress) {
        var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
        return pattern.test(emailAddress);
    };
    $('#register_form').on('submit', function () {
        var pass = true;

        var user_type = $('#user_user_type_id').val()
        $('.mandatory').each(function () {
            if ($(this).val() == '' || $(this).val().length == 0 || $(this).val() == 'undefined' || $(this).val() == '0' || $(this).val() == '请先选择国家') {
                $(this).css('border', '1px solid red')
                if($(this).attr('id')=='user_university_box'){
                    if(user_type==1){
                        pass = false;
                    }
                }
                else{
                    pass = false;
                }
            } else {
                $(this).css('border', '1px solid #c9cdcd')
            }
        });

        if (!isValidEmailAddress($('#user_email').val())) {
            $('#email_warning').text('邮箱格式不正确')
            pass = false;
        } else {
            $('#email_warning').text('');
        }
        if (pass == true) {
            var val = [];
            $.each($('.subject_tick_box_item'),function(i,v){
                if($(this).attr("tick")=="true"){
                    val.push($(this).attr("subject-id"))
                }
            })
            var input = $("<input>")
                .attr("type", "hidden")
                .attr("id", "subject_selected")
                .attr("name", "subject_selected").val(val);
            $('#register_form').append($(input));
            $('#warning').text('')
            return true;
        } else {

            $('#warning').text("请填写所有信息")
            $('#submit').removeAttr("disabled")
            return false;
        }
    })

    var show_drop = 0
    $('html').click(function () {
        if (show_drop == 1) {
            $('#register_uni_dropdown').html("");
            show_drop = 0;
        }
    });
    if ($('#user_user_type_id').val() == 2) {
        $('.taker_only').show()
        $('.maker_only').hide()
        $('.maker_only').val("")
    } else {
        $('.taker_only').hide()
        $('.maker_only').show()
        if ($('#user_country_id').val() == "") {
            $('#user_university_box').attr("disabled", "disabled")
            $('#user_university_box').val("请先选择国家")
        } else {
            $('#user_university_box').removeAttr("disabled")
            $('#user_university_box').val("")
        }
    }

    $('#user_country_id, #user_user_type_id').on('change', function () {
        var countryObj = $('#user_country_id');
        var url = 'get_university_by_country';
        if ($('#user_user_type_id').val() == 2) {
            url = 'get_writer_university_by_country';
            $('.taker_only').show()
            $('.maker_only').hide()
            $('.maker_only').val("")
        } else {
            $('.taker_only').hide()
            $('.maker_only').show()
            if ($('#user_country_id').val() == "") {
                $('#user_university_box').attr("disabled", "disabled")
                $('#user_university_box').val("请先选择国家")
            } else {
                $('#user_university_box').removeAttr("disabled")
                $('#user_university_box').val("")
            }
        }
        $.ajax({
            url: '/' + url,
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
                $.each(newOptions, function (key, value) {
                    $el.append($("<option></option>")
                        .attr("value", value.id).text(value.name));
                });
            }
        });
    });

    $('#user_email').on('blur', function () {
        if (!isValidEmailAddress($(this).val())) {
            $('#email_warning').text('邮箱格式不正确')
        } else {
            $('#email_warning').text('');
        }
    });

    $('#user_university_box').on('keyup', function () {
        var str = $(this).val()
        var country_id = $('#user_country_id').val();
        if (str.length >= 3 && country_id != '') {
            $.ajax({
                url: '/find_country/',
                type: 'get',
                beforeSend: function (xhr) {
                    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                },
                data: {input: str, country_id: country_id},
                dataType: 'json',
                success: function (data) {
                    show_drop = 1
                    var newOptions = data;
                    var $el = $('#register_uni_dropdown');
                    var html = "";
                    $.each(newOptions, function (key, value) {
                        html += "<div class='register_uni_row pick_country' onclick=\"$('#user_university_box').val('" + value.name + "');$('#register_uni_dropdown').html('')\">" + value.name + "</div>"
                    });
                    $el.html(html)
                }
            });
        }
    })
})

