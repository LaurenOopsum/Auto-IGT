extends DropDown



func select_action(idx : int) :
	match idx :
		C.LANG.ENGLISH : TranslationServer.set_locale("en")
		C.LANG.SPANISH : TranslationServer.set_locale("es")
