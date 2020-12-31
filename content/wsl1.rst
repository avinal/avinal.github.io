**********************************
Move WSL 2 Safely to another Drive
**********************************

:date: 2020-12-31 19:07
:tags: wsl, wsl2
:category: development

It is real pain when you have small SSD and Windows Subsystem for Linux (WSL) is growing exponentially in size. There no easy way to move 
the WSL installation to another drive. Here in this blog I will discuss how to tackle this problem with bite size steps. 

.. |powershell| image:: /images/powershell.png
    :width: 5%
    :align: middle

.. |command-line| image:: /images/command-line.png
    :width: 5%
    :align: middle

.. |windows10| image:: /images/windows10.png
    :width: 5%
    :align: middle
    :alt: WinKey

.. role:: html-raw(raw)
    :format: html

1. Open a PowerShell |powershell| or Command Prompt |command-line| with *Admin* access. For this you can use |windows10| + X shortcut and select **Windows PowerShell(Admin)**.
2. Check if the WSL 2 installation you are planning to move is is currently running/stopped.

.. code-block:: powershell

    PS C:\Users\Avinal> wsl -l -v
    PS C:\Users\Avinal>
      NAME      STATE           VERSION
    * Ubuntu    Running         2
      Kali      Stopped         2

3. If its running then you must stop the particular WSL distribution. (*Ubuntu* used as example)

.. code-block:: powershell

    PS C:\Users\Avinal> wsl -t Ubuntu

4. Export to some folder. (Here exporting *Ubuntu* as *ubuntu-ex.tar* to *Z:\wsl2*)

.. code-block:: powershell

    PS C:\Users\Avinal> wsl --export Ubuntu "Z:\export\ubuntu-ex.tar"

5. Unregister previous WSL installation

.. code-block:: powershell

    PS C:\Users\Avinal> wsl --unregister Ubuntu

6. Create a new folder and import your WSL installation to that folder.

.. code-block:: powershell

    PS C:\Users\Avinal> New-Item -Path "Z:\wsl2" -ItemType Directory

        Directory: Z:\

    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    d-----        31-12-2020     21:03                wsl2

    PS C:\Users\Avinal> wsl --import Ubuntu "Z:\wsl2" "Z:\export\ubuntu-ex.tar"

7. Check after import is complete

.. code-block:: powershell

    PS C:\Users\Avinal> wsl -l -v
    PS C:\Users\Avinal>
      NAME      STATE           VERSION
    * Ubuntu    Running         2
      Kali      Stopped         2

8. Mark one of your WSL distribution as *(default)*.

.. code-block:: powershell

    PS C:\Users\Avinal> wsl -s Ubuntu

9. After exporting your default user will be set as :html-raw:`<i style="color:red">root</i>` , to change it to your desired username, run following command

.. code-block:: powershell

    PS C:\Users\Avinal> ubuntu config --default-user user_name

10. Finally run :code:`wsl` and you have successfully moved your WSL 2 installation to another drive.