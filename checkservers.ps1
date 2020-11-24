$Servers = "DS01","DS02","DS03","DS04"

   $Results = @()
   $Results = Invoke-Command -cn $Servers {
      $Certs = @{} | Select Certificate,Expired
      $Cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.subject -match [Environment]::GetEnvironmentVariable("computername")}
      If($Cert){
          $Certs.Certificate = $Cert.subject
          $Certs.Expired = $Cert.NotAfter
      }
      Else{
          $Certs.Certificate = " - "
          $Certs.Expired = " - "
      }
      $Certs } | Select-Object @{n='ServerName';e={$_.pscomputername}},Certificate,Expired

  $Results | Sort-Object Expired -Descending
