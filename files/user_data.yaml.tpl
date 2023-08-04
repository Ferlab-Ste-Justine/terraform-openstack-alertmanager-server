#cloud-config
merge_how:
 - name: list
   settings: [append, no_replace]
 - name: dict
   settings: [no_replace, recurse_list]

ssh_pwauth: false
preserve_hostname: false
hostname: ${hostname}
users:
  - default

%{ if length(receiver_secrets) > 0 ~}
write_files:
%{ for secret in receiver_secrets ~}
  - path: ${secret.path}
    owner: root:root
    permissions: "0400"
    content: |
      ${indent(6, secret.content)}
%{ endfor ~}

runcmd:
%{ for secret in receiver_secrets ~}
  - chown alertmanager:alertmanager ${secret.path}
%{ endfor ~}
%{ endif ~}