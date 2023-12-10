*** Settings ***
Library    SeleniumLibrary
Library    String

*** Variables ***
#Configurations Variables
${url}    http://automationexercise.com

#Test Variables
${searchText}    men tshirt

#MenuButtons
${productsMenuBtn}    xpath://*[@id="header"]/div/div/div/div[2]/div/ul/li[2]/a
${cartMenuBtn}        xpath://a[contains(text(), 'Cart')]

#Products Page
${searchBar}       id:search_product
${submitSearch}    id:submit_search

#Products Results Page
${menTshirt}           xpath://p[contains(text(), 'Men Tshirt')]
${blueTop}             xpath://p[contains(text(), 'Blue Top')]
${addToCart}           xpath://a[contains(text(), 'Add to cart')]
${continueShopping}    xpath://button[normalize-space()='Continue Shopping']

#CartPage
${menTshirtCart}          xpath://a[contains(text(), 'Men Tshirt')]
${tshirtValueElement}     xpath://p[@class='cart_total_price'][normalize-space()='Rs. 400']
${blueTopCart}            xpath://a[normalize-space()='Blue Top']
${blueTopValueElement}    xpath://p[@class='cart_total_price'][normalize-space()='Rs. 500']
${cartItemsSum}           900


*** Keywords ***
Given the user go to the exercise page
    Open browser    ${url}    chrome

And the user click on 'Products'
    Click Element    ${productsMenuBtn}

And the user search for 'men tshirt'
    Element Should Be Visible    ${searchBar}
    Input Text                   ${searchBar}       ${searchText}
    Click Element                ${submitSearch}
    Element Should Be Visible    ${menTshirt}

And the user add the product to cart
    Execute Javascript    window.scrollTo(0, 500)
    Click Element         ${addToCart}

And the user add a second item
    Wait Until Element Is Visible    ${continueShopping}    3s
    Click Element                    ${continueShopping}
    Element Should Be Visible        ${searchBar}
    Input Text                       ${searchBar}           blue top
    Click Element                    ${submitSearch}
    Element Should Be Visible        ${blueTop}
    Click Element                    ${addToCart}

When the user click on 'Cart' in menu
    Click Element    ${cartMenuBtn}

Then the sum of the product values must be correct
    Element Should Be Visible    ${menTshirtCart}
    Element Should Be Visible    ${blueTopCart}
    ${tshirtValue}=              Get Text              ${tshirtValueElement}
    ${blueTopValue}=             Get Text              ${blueTopValueElement}
    #Format text
    ${tshirtValue}=              Remove String         ${tshirtValue}            Rs.
    ${tshirtValue}=              Convert To Integer    ${tshirtValue}
    ${blueTopValue}=             Remove String         ${blueTopValue}           Rs.
    ${blueTopValue}=             Convert To Integer    ${blueTopValue}
    ${cartItemsSum}=             Convert To Integer    ${cartItemsSum}


    ${result}=         Evaluate     int(${tshirtValue})+int(${blueTopValue})
    Should Be Equal    ${result}    ${cartItemsSum}

*** Test Cases ***
Test 1: Validate end to end flow for cart feature
    Given the user go to the exercise page
    And the user click on 'Products'
    And the user search for 'men tshirt'
    And the user add the product to cart
    And the user add a second item
    When the user click on 'Cart' in menu
    Then the sum of the product values must be correct