BubbleBath
=====================
[![Build Status](https://secure.travis-ci.org/sandwichclub/bubblebath.png?branch=master)](http://travis-ci.org/sandwichclub/bubblebath)
[![Coverage Status](https://coveralls.io/repos/sandwichclub/bubblebath/badge.png)](https://coveralls.io/r/sandwichclub/bubblebath)


 * https://github.com/sandwichclub/bubblebath
 * library for interfacing with SOAP and REST web services
 * leverages SoapUI's powerful schema compliance engine for soap message assertions


Structure
=====================
    SOAP:
    `MyApplicationSoapClient < Bubblebath::SoapApi::SoapClient

    MyOperation < MyApplicationSoapClient`

    REST:
    `MyApplicationRestClient < Bubblebath::RestApi::RestClient

    MyOperation < MyApplicationRestClient`

BubbleBath Gli Generator
    ===================

    Getting Started
    ---
    To generate a new project:

    ```bash
    # develop mode
    ##check current version
    bundle exec bin/bubblebath-gli-generator -v
    ## Or
    $ bundle exec bin/bubblebath-gli-generator --version
    ```

    ```bash
    # develop mode
    ##create a new project
    $ bundle exec bin/bubblebath-gli-generator new my_test_project
    ```
