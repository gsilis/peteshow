describe 'PeteShow', ->

  beforeEach (done) ->
    browser.visit('/')
      .then ->
        initPeteshow = "Peteshow.init({
          rules: {
            'input[name*=zip]'              : '60611',
            'input[name*=middle_name]'      : Peteshow.random.firstName(),
            'input[name*=custom_name]'      : function() { return 'Custom'; },
            'input[name*=boolean_checkbox]' : true
          },
          ignore : ['input[name=ignore_me]']
        });"
        browser.evaluate("Peteshow.store.clear()")
        browser.evaluate(initPeteshow)
        done()

  it 'is running the test server', (done) ->
    browser.assert.success()
    done()

  it 'exists in the DOM', (done) ->
    browser.assert.element('.peteshow')
    done()

  it 'is accessible in javascript', (done) ->
    browser.assert.global('Peteshow')
    done()

  it 'opens peteshow Peteshow.open(true)', (done) ->
    browser.evaluate("Peteshow.open(false)")
    browser.assert.hasNoClass('.peteshow', 'open')
    browser.evaluate("Peteshow.open(true)")
    browser.assert.hasClass('.peteshow', 'peteshow', 'open')
    done()

  it 'closes peteshow Peteshow.open(false)', (done) ->
    browser.evaluate("Peteshow.open(true)")
    browser.assert.hasClass('.peteshow', 'peteshow', 'open')
    browser.evaluate("Peteshow.open(false)")
    browser.assert.hasNoClass('.peteshow', 'open')
    done()

  it 'shows peteshow with Peteshow.show()', (done) ->
    browser.evaluate("Peteshow.hide()")
    browser.evaluate("Peteshow.show()")
    browser.assert.style('.peteshow', 'display', '')
    done()

  it 'hides peteshow with Peteshow.hide()', (done) ->
    browser.evaluate("Peteshow.hide()")
    browser.assert.style('.peteshow', 'display', 'none')
    done()

  it 'should have valid values', (done) ->
    browser.assert.evaluate('Peteshow.fillOutForms()')

    fields =
      'input[type=password]'      : 'password'
      'input[type=text]'          : REGEX.TEXT
      'input[type=email]'         : REGEX.EMAIL
      'input[type=number]'        : REGEX.TEXT
      'input[type=date]'          : REGEX.DATE
      'input[type=tel]'           : REGEX.PHONE
      'input[name*=decimal]'      : REGEX.NUMBER
      'input[name*=first_name]'   : REGEX.TEXT
      'input[name*=last_name]'    : REGEX.TEXT
      'input[name*=company]'      : REGEX.TEXT
      'input[name*=street]'       : REGEX.TEXT
      'input[name*=line1]'        : REGEX.TEXT
      'input[name*=line2]'        : REGEX.TEXT
      'input[name*=suite]'        : REGEX.TEXT
      'input[name*=city]'         : REGEX.TEXT
      'input[name*=county]'       : REGEX.TEXT
      'input[name*=zip]'          : REGEX.ZIP_CODE
      'input[name*=postal]'       : REGEX.ZIP_CODE
      'input[name*=state]'        : REGEX.TEXT
      'input[name*=job_title]'    : REGEX.TEXT
      'input[name*=intent]'       : REGEX.TEXT
      'input[name*=income]'       : REGEX.NUMBER
      'input[name*=amount]'       : REGEX.NUMBER
      'input[name*=branch]'       : '400001'
      'input[name*=routing]'      : '400001'
      'input[name*=card_type_cd]' : '001'
      'input[name*=card_number]'  : '4111111111111111'
      'input[name*=cvv]'          : '123'

    for element, match of fields
      # message = "#{element} failed"
      message = message || null
      browser.assert.inputFirst(element, match, message)
    done()

  it 'should ignore fields', (done) ->
    browser.assert.evaluate('Peteshow.fillOutForms()')
    browser.assert.inputFirst('input[name=ignore_me]', "")
    done()

  it 'should have valid values from plugin after filling out forms', (done) ->
    browser.assert.evaluate('Peteshow.fillOutForms()')
    browser.assert.inputFirst('input[name*=zip]', 60611)
    browser.assert.inputFirst('input[name*=custom_name]', 'Custom')
    done()

  it 'should not change value of checkbox but attribute checked', (done) ->
    browser.assert.evaluate('Peteshow.fillOutForms()')
    browser.assert.evaluate("$('input[name=boolean_checkbox]').val()", 1)
    browser.assert.evaluate("$('input[name=boolean_checkbox]').prop('checked')", true)
    done()
