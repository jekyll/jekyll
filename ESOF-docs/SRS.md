#Requirement Specification

<a name="index"/>
##Index
1. [Description](#description)
2. [System Requirements](#system_requirements)
3. [User Files](#user_files)
4. [Requirement History](#requirement_history)
5. [Hosts](#hosts)
6. [Use case diagram](#use_case_diagram)

<a name="description"/>
##Description
Jekyll stands as a software able to read your markup files and process them into a static website. It is all based on your content, rather than databases or comment moderation. You can read more about Jekyll in our first report: https://github.com/jmepg/jekyll/blob/master/ESOF-docs/First%20report.md or directly on Jekyll website: https://jekyllrb.com/

<a name="system_requirements"/>
##System Requirements
 So the software must be able to read *markup languages* (Markdown, Textile, HTML). 
Jekyll is best supported by *Linux* (although you are still able to use with it through some other operative systems). You are required  to have *Ruby* and *RubyGems* in order to run the software.

![System Requirements](./Resources/sysReq.png)


<a name="user_files"/>
##User Files
The directory structure of your files should look like this:

![Directory Structure](./Resources/configuration.png)

Therefore, a major requirement for the softwarwe understands and recognizes this structure, which is crucial for the genarating of your website.

<a name="requirement_history"/>
##Requirement History

Jekyll keeps record of their releases, bug fixes and feature implementation so that they can track their way, understand the software and user needs and see the course their implemetation has followed. It is explicited here: http://jekyllrb.com/docs/history/

Since Jekyll is still in development, adding new features and fixing bugs, it is possible through the *issues*, *releases*, *labels* and *pull requests* to understand more of its requirements. 
The majority of pull requests ask for a more user friendly aproach and a improved user support. 
Jekyll developed Jekyll Talk in response to the matter. 

![Jekyll Talk front page](./Resources/jkTalkFront.png)

It is a debate forum where you can ask, answer and discuss anything Jekyll related, from your late masterings of Jekyll to your troubleshooting. Its a great platform. It stores info in diversed categories and allows you to sort the content that you are really looking for. In addiction they have a *troubleshooting* area to answer FAQS, which you can find here: http://jekyllrb.com/docs/troubleshooting/

<a name="hosts"/>
##Hosts

Since Jekyll only generates your static website, you will need somewhere to host it. As they recomend, GitHub stands a great place to host your website GitHub Pages are powered by Jekyll behind the scenes, so in addition to supporting regular HTML content, they are also a great way to host your Jekyll-powered website for free.
GitHub Pages work by looking at certain branches of repositories on GitHub. There are two basic types available: user/organization pages and project pages. The way to deploy these two types of sites are nearly identical, except for a few minor details. You can find more on that here: http://jekyllrb.com/docs/github-pages/

<a name="use_case_diagram"/>
##Use case diagram

![Use case Model](./Resources/use_case.png)







