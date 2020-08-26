import 'dart:async';

mixin Validators{

  var emailValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (email,sink){
        if(email.contains('@') && email.contains('.')){
          sink.add(email);
        }else{
          sink.addError("Email is not valid");
        }
      }
  );

  var passwordValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (password,sink){
        if(password.length > 5){
          sink.add(password);
        }else{
          sink.addError("Password length can\'t be less than 6 chars.");
        }
      }
  );

}