Namespace('Wordguess').Creator = do ->
	isMobile = navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry)/)

	# Data that may be pre-established.
	wordsToSkip           = null
	_qset                 = null

	initNewWidget = (widget, baseUrl) ->
		wordsToSkip           = 3
		manualSkippingIndices = []

		Wordguess.CreatorEvents
			.cacheElements()
			.setEventListeners(isMobile)
			.setSecondMenuEventListeners()

	initExistingWidget = (title, widget, qset, version, baseUrl) ->
		wordsToSkip = qset.wordsToSkip
		previousWordsToSkip = qset.previousWordsToSkip
		previousMode = undefined

		# figure out if what was the previously selected mode
		if wordsToSkip == -1
			previousMode = 'manual'
		else
			previousMode = 'automatic'

		console.log 'words too skip', wordsToSkip
		# set default value
		if wordsToSkip == -1

			if previousWordsToSkip != undefined and previousWordsToSkip != -1
				console.log 'previousWordsToSkip', previousWordsToSkip
				wordsToSkip = previousWordsToSkip
			else
				console.log 'wordsToSkip', wordsToSkip
				wordsToSkip = 3


		manualSkippingIndices = qset.manualSkippingIndices

		Wordguess.CreatorEvents
			.cacheElements()
			.setEventListeners(isMobile)
			.setSecondMenuEventListeners()
			.initializeWordsToSkip(wordsToSkip)
		Wordguess.CreatorUI
			.setInputValues(title, qset.paragraph, wordsToSkip)

		Wordguess.CreatorLogic
			.initializeHiddenWords(manualSkippingIndices, qset.paragraph)
		
		Wordguess.CreatorEvents
			.storeHiddenWords()

		# set screen to state after clicking next
		Wordguess.CreatorEvents
			.onNextClick(previousMode)

	onSaveClicked = (mode = 'save') ->
		titleValue = document.getElementById('title').value
		if titleValue then widgetTitle = Wordguess.CreatorLogic.replaceTags(titleValue)
		else widgetTitle = 'New Wordguess Widget'

		_qset = Wordguess.CreatorLogic.buildSaveData()

		if _qset == null then return false
		
		Materia.CreatorCore.save widgetTitle, _qset

	onSaveComplete = (title, widget, qset, version) -> true

	# Public methods, called by Materia.
	initNewWidget      : initNewWidget
	initExistingWidget : initExistingWidget
	onSaveClicked      : onSaveClicked
	onSaveComplete     : onSaveComplete