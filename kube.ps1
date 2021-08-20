kubectl.exe  get pod -n systest --kubeconfig=C:\Users\TarunB-PC\.kube\config-laptop1 | Out-File -FilePath E:\tarun.txt
kubectl.exe  run nginx-test-test --image=nginx -n systest --kubeconfig=C:\Users\TarunB-PC\.kube\config-laptop1 | Out-File -FilePath --Append E:\tarun.txt
