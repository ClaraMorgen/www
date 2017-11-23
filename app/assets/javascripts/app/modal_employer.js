function showModalIfError(id, condition){
  $(document).ready(function() {
    if(condition){
      $(id).modal('show');
    };
  });
}
