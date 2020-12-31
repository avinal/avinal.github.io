**************************************************************
Create the VLC User Documentation for one Mobile Port(Android)
**************************************************************

:date: 2020-12-01 23:47
:modified: 2020-12-31 23:19
:slug: vlc-gsod-report
:category: blog
:tags: vlc, gsod, gsod2020

OVERVIEW
--------

VideoLAN is a non-profit organization that develops software for playing video and other media formats. VLC media player (commonly known as just VLC) is a free and Open Source cross-platform multimedia player and framework that plays most multimedia files as well as DVDs, Audio CDs, VCDs, and various streaming protocols built by the VideoLAN organization and a team of volunteers. VLC for Android is a port of the VLC for Android OS.


The project was to Create the VLC User Documentation for Android Mobile Port which was previously hosted on VLC’s wiki pages. The major portion of this was to start everything from scratch including chapter separation, section organisation and an engaging and easy to follow for both technical and non-technical users. The original proposal can be found here.


PROJECT GOALS
-------------

* Propose a new structure for documentation e.g. Chapter Separation, Sections etc
* Proper balance between technical and non-technical descriptions to serve all kinds of users.
* Adequate amount of screenshots in each section and other supporting media to make documentation more appealing.
* Optimised for all Screen Sizes. Especially for Mobile Devices.
* Ease of navigation

COMMUNITY BONDING
-----------------

This period was mostly utilized for collecting more information and many internal meetings to shape the projects and bonding with fellow writers, developers(mentors). I got to know more about the VLC organisation and the project. We decided to create a skeleton of the project and then follow a Issue-Merge Request-Review-Merge system to keep the commit history clean and maintain the proper review of the work before it is merged. 


I initially proposed that the new documentation should also use the same tools(Sphinx and GitLab Pages) because if in future we want to merge all the documentation into a single one, it will be easier to migrate and will provide a consistency across all documentations.  Later I got to know that this will be an independent project and may not be merged since it solves a lot of problems. I was already familiar with the tools so it took no time to get started. 


Nicolas Pomepuy, who is the lead developer of VLC for Android was assigned as my primary mentor and Simon Latapie as secondary mentor. 


DOCUMENTATION DEVELOPMENT PHASE
-------------------------------

Initial Preparation
I first moved my existing demo documentation to an entirely new repository with only the skeleton at the suggestion of my mentor. It was necessary to keep the commit history clean. The skeleton contained the empty directories representing the chapter separation. I got to learn “how to properly develop a project and contribute to open source”. This was a major lesson that got me familiar with the Merge Request and Review system. 


The Development
The next part was to frame the actual documentation pages and push to the repository. Since there was a significant time-zone difference we agreed to discuss by creating issues and sometimes my emails. There was one meeting every fortnight to check the process and discuss further development and blockers. Nicolas was really helpful and patient, answering each of my big-small queries. 

Work Done

.. raw:: html

    <style>
    table,td,th {
    border-collapse:collapse;
    border: 1px solid #000000;
    }
    </style>
    <table>
    <tr>
    <td><strong>Documentation</strong></td>
    <td><a href="https://avinal.videolan.me/vlc-android-user/">VLC for Android User Documentation </a>
    </td>
    </tr>
    <tr>
    <td><strong>Project Repository</strong>
    </td>
    <td><a href="https://code.videolan.org/avinal/vlc-android-user">Projects · Avinal Kumar / VLC for Android User Documentation</a>
    </td>
    </tr>
    <tr>
    <td><strong>Commits</strong>
    </td>
    <td><a href="https://code.videolan.org/avinal/vlc-android-user/-/commits/master">Commits · Avinal Kumar / VLC for Android User Documentation</a>
    </td>
    </tr>
    <tr>
    <td><strong>Issues/Discussions</strong>
    </td>
    <td><a href="https://code.videolan.org/avinal/vlc-android-user/-/issues">Issues · Avinal Kumar / VLC for Android User Documentation</a>
    </td>
    </tr>
    <tr>
    <td><strong>Merge Requests</strong>
    </td>
    <td><a href="https://code.videolan.org/avinal/vlc-android-user/-/merge_requests">Merge Requests · Avinal Kumar / VLC for Android User Documentation</a>
    </td>
    </tr>
    </table>


Since the Android port of VLC can be installed on Android Smartphones/Tablets, Android TVs, Amazon Fire Devices and Chromebooks too, a full documentation will cover these all devices. Although these are different form factors, the features provided on each of them is exactly the same and the same documentation can be used for all these devices. As of now only Smartphones/Tablets are covered. And later additional pages will be added to reference different features/User Interface. Regardless of this addition the current documentation can serve a major part for all these form factors. 
Completed/Remaining

.. raw:: html

    <table>
    <tr>
    <td><strong>Chapters</strong>
    </td>
    <td><strong>Sections</strong>
    </td>
    <td><strong>Status</strong>
    </td>
    </tr>
    <tr>
    <td><strong>Settings</strong>
    </td>
    <td>
    <ul>
    <li>General Settings
    <li>Interface
    <li>Video
    <li>Subtitles
    <li>Audio
    <li>Casting
    <li>Advanced
    </li>
    </ul>
    </td>
    <td><strong>ALL COMPLETED</strong>
    <p>
    <strong>FOR ALL FORM FACTORS</strong>
    </td>
    </tr>
    <tr>
        <td><strong>Video</strong>
        </td>
        <td>
            <ul>
                <li>Video Explorer
                <li>Video Player
                </li>
            </ul>
        </td>
        <td><strong>COMPLETED FOR SMARTPHONES/TABLETS</strong>
        </td>
    </tr>
    <tr>
        <td><strong>Audio</strong>
        </td>
        <td>
            <ul>
                <li>Audio Explorer
                <li>Audio Player
                </li>
            </ul>
        </td>
        <td><strong>COMPLETED FOR SMARTPHONES/TABLETS</strong>
        </td>
    </tr>
    <tr>
        <td><strong>Browse</strong>
        </td>
        <td>
            <ul>
                <li>Explorer
                <li>Local Network
                </li>
            </ul>
        </td>
        <td><strong>ONLY SMB IN LOCAL NETWORK COMPLETED</strong>
        </td>
    </tr>
    <tr>
        <td><strong>Installation</strong>
        </td>
        <td>
            <ul>
                <li>Smartphones/Tablets
                <li>Android TV
                <li>Fire Devices
                <li>Chromebooks
                </li>
            </ul>
        </td>
        <td><strong>COMPLETED FOR SMARTPHONES/TABLETS</strong>
        </td>
    </tr>
    <tr>
        <td><strong>User Interface</strong>
        </td>
        <td>
            <ul>
                <li>Smartphones/Tablets
                <li>Android TV
                <li>Fire Devices
                <li>Chromebooks
                </li>
            </ul>
        </td>
        <td><strong>COMPLETED FOR SMARTPHONES/TABLETS</strong>
        </td>
    </tr>
    <tr>
        <td><strong>Support</strong>
        </td>
        <td>
            <ul>
                <li>FAQs
                <li>Help
                </li>
            </ul>
        </td>
        <td><strong>IN PROGRESS</strong>
        </td>
    </tr>
    <tr>
        <td><strong>Guidelines</strong>
        </td>
        <td>
            <ul>
                <li>Contribution Guideline
                <li>Screenshot Guidelines
                <li>READMEs
                </li>
            </ul>
        </td>
        <td><strong>IN PROGRESS</strong>
        </td>
    </tr>
    </table>


CHALLENGES
----------

The major obstacle was to get screenshots for all form factors. Since screenshots were the major part of this documentation it was necessary to provide proper screenshots in each chapter and with every step. For Android TV and Smartphone this was solved by using emulators instead of actual devices, but to emulate the actual scenario in an emulator was sometimes very difficult. 
There were many occasions where I was not able to gather the exact information about devices other than smartphones/tables. Since all form factors share a common pool of features, my mentor suggested that I focus on smartphones/tables. And to create issues mentioning missing parts so that it could be solved later. 


THANKS
------

I want to thank my mentors for being supporting and helpful. I want to thank every person at VLC and Google who were involved in this whole process. Thanks and Congrats to my fellow writer Abhishek Pratap Singh. This was a great opportunity to learn and meet awesome people. I learned a lot about Sphinx, reStructured Text and many other things. 
   
