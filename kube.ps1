kubectl.exe  get pod -n systest --kubeconfig=C:\Users\TarunB-PC\.kube\config-laptop1 | Out-File -FilePath E:\tarun.txt
kubectl.exe  run nginx-test-test --image=nginx -n systest  | Out-File -Append -FilePath E:\tarun.txt
