function doExpand(id, idBtn, idFld){
	if (id.style.display == "none") {
		id.style.display = "";
		idBtn.src = "collapse.gif"
		idFld.src = "openbook.gif"
	} else {
		id.style.display = "none";
		idBtn.src = "expand.gif"
		idFld.src = "closebook.gif"
	}
}

