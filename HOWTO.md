
# New Setup or Reset Mac from Intune



## All New or Reset Intune Registered Mac Steps

### Pre-requisites

- You've completed the initial Microsoft SSO account setup and can login to
  https://myaccount.microsoft.com with your company provided credentials
- You've a managed Apple ID associated with your company provided Microsoft account
- You've read thru the steps below and know whether you want to use Ansible to
  deploy any additional software or migrate archived settings from your existing
  Mac

### Steps

1. Power on the Mac and activate - note: if WiFi is not available the Mac can be
   activated via Ethernet
2. Proceed thru the Intune Registered Mac setup process:
    1. Select Your Country or Region
    2. Accessibility
    3. Select You Wi-Fi Network
    4. Remote Management - denotes the ownership and remote management ability
    5. Prompt for Microsoft Single Sign-On to enable Remote Management
    6. Sign-in with Your Apple ID
        - Enter the managed Apple ID associated with your company SSO account
          and select Continue when prompted
        - Apple ID redirect to Microsoft Single Sign-On - Confirm your credentials

    7. Terms and Conditions
        - Select the checkbox and press Agree

    8. Create a Computer Account
        - Your Full Name and an Account name are pre-populated
        - Enter a strong password
        - Maintain the checkbox to allow self-service recovery using your
          managed Apple ID
    9. Find My
    10. Make This Your New Mac
        - Select Customize Settings
        - Select Your Time Zone - checked box
        - FileVault Disk Encryption - checked box
        - FileVault Disk Encryption - Continue
        - Touch ID - Set Up Touch IT Later or Continue
    11. Desktop opens
    12. Reboot
    13. Open "Company Portal" to confirm compliance checks

## Using ansible-osx-setup

### Prerequisites

- You've copied or forked this repository for your custom configurations
- Review the configuration in the [ansible_osx.yml](ansible_osx.yml) file
- If you are migrating from another Mac, run the archive.sh on the source Mac

### Steps

1. Open Terminal and enter: `git`
    - Press "Install" button when prompted to install XCode Developer Tools
    - Press "Agree" button

2. In the Terminal window, enter the following replacing with your repo URL:

        git clone [https://github.com/jasonsears/ansible-osx-setup.git]
        cd ansible-osx-setup
        bin/bootstrap
        <Enter your account password and any acknowledgements when prompted>

    The bootstrap process will install libraries and Ansible. It will then
    execute the Ansible playbook: [ansible_osx.yml](ansible_osx.yml). You will 
    immediately be prompted for the `BECOME password:`, enter your local account
    password you've setup.

    NOTE: If you kept the VSCode extensions section of the playbook the
    bootstrap execution will error on the section. This is due to VSCode needing
    to have been initiated.

3. Open a new terminal window and open VSCode, i.e. type `code`
4. Execute the `bin/apply` to deploy the VSCode extensions

        cd ansible-osx-setup
        bin/apply
        <Enter your BECOME password when prompted>

## Preparing for Mac reset

The following steps use the [bin/archive.sh](bin/archive.sh) script to create
archive files located under the company OneDrive folder
[OneDrive - Company Name]/Archive/macos/[archive name]. 

The target settings are:

- SSH Keys located in ~/.ssh
- Fonts located in ~/Library/Fonts
- Microsoft Remote Desktop Connection settings
- Microsoft Teams backgrounds
- Microsoft Outlook signatures - note the steps below when restoring
- OpenVPN profiles

Before executing the script, review the 

1. Open Terminal, enter the following replacing with your repo URL:

        git clone [https://github.com/jasonsears/ansible-osx-setup.git]
        cd ansible-osx-setup
        bin/archive.sh -a <archive name>

## Restore settings from previous Mac using archive.sh script

1. 