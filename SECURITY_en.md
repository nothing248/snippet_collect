[English](SECURITY_en.md) | [简体中文](SECURITY.md)

# 🛡️ Security Policy

Thank you very much for your attention to the security of **Snippet Collector**. Because this project involves calls with relatively high privileges in multiple environments (such as Accessibility permissions, system global hotkey detection, log listening, and floating window interception), security and user privacy protection have always been the primary guiding principles of the community architecture maintenance group.

## Supported Versions

Currently, only the latest features and functionalities on the `main` branch are actively supported with security updates and patches. It is recommended that all deployed instances operate on the latest release nodes.

## Reporting a Vulnerability

If you discover critical issues in the code framework itself or surrounding dependent libraries that could be maliciously exploited for privilege escalation, command execution injection, or irregular invocation leaks involving system privacy and security-sensitive data:

**🚨 Please ABSOLUTELY DO NOT** report them through publicly visible GitHub Issue pages or discussion boards, in order to prevent details of this vulnerability from being exposed and suffering wider malicious exploitation before a fix is implemented.

Please prioritize using the [Private Vulnerability Reporting Mechanism] provided by GitHub, which is currently the most secure and trackable collaboration channel. If you are unable to use this feature for any reason, you can also contact us confidentially via a protected email.

🔒 **Priority Channel: GitHub Private Vulnerability Reporting**  
Please go to the top navigation bar of this repository, navigate to the **Security** tab -> **Advisories** -> click the **Report a vulnerability** button to submit.

📧 **Alternative Email Channel**: `[Replace with your secure receiving email here -> e.g., security@snippetcollector.team]`

After receiving your reporting process execution plan, we will:
1. Respond immediately, acknowledging and documenting the analysis of the report content within at most **48 hours**.
2. The architecture group will allocate the highest level of resources to conduct an investigation and plan a full-platform repair update release package in the shortest time with feasible measures.
3. If a high-risk vulnerability report is verified and rectified, provided that you follow this confidentiality specification, we will express our profound gratitude and recognize your contribution in the Release Notes and the maintainer circle (of course, we will unconditionally respect and protect any wish you might have to remain hidden and anonymous).

**Please NEVER publish any related reproducible analysis speculations or vulnerability Proof of Concept (PoC) code on any public channels, and even avoid asking questions or discussing it until the corresponding serious defect has received a full-chain fix.** We are deeply grateful to all white hats and security developers who work together with us to protect the security of the open-source community!
