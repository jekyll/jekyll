#Verification and Validation

##Introduction 

In this report, we will explain verification and validation of software and how Jekyll implements tests.

##Verification vs Validation

**Verification** - "The evaluation of whether or not a product, service, or system complies with a regulation, requirement, specification, or imposed condition. It is often an internal process." (https://en.wikipedia.org/wiki/Verification_and_validation)

**Validation** - " The assurance that a product, service, or system meets the needs of the customer and other identified stakeholders. It often involves acceptance and suitability with external customers." (https://en.wikipedia.org/wiki/Verification_and_validation)

But what does this mean?
Verification stands as understanding if the software developed meets the specifications given at the beggining.
Validation is knowing if the custumores/stakeholders(who might benefit with the software) are happy with the software developed, if it meets their expectations.

##Software Testing

To check if the software is well implemented, Jekyll set a wide variety of tests. We will expose them in order to understand where they focus on.

###Controlability

**Controlabilty** determines the work it takes to set up and run test cases and the extent to which individual functions and features of the system under test (SUT) can be made to respond to test cases. 
Jekyll deals with the matter testing every class, module and package, one at a time. Jekyll tests evry render, every parser to ensure everything is correct. (There is more info on this in the previous reporst. Check https://github.com/jmepg/jekyll/tree/master/ESOF-docs for detailed description).  This allow to have more control over what is going on.

This ensures that Jekyll component testing is controlable.

###Observability 

**Observability** determines the work it takes to set up and run test cases and the extent to which the response of the system under test (SUT) to test cases can be verified.

Jekyll sets up a free build environment on [*Travis*](https://travis-ci.org/), with [*GitHub*](https://github.com/) integration for pull requests. 

