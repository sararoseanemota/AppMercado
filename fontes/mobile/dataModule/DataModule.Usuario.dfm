object DmUsuario: TDmUsuario
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 223
  Width = 250
  object TabUsuario: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 24
    Top = 40
  end
  object conn: TFDConnection
    AfterConnect = connAfterConnect
    BeforeConnect = connBeforeConnect
    Left = 128
    Top = 40
  end
  object QryGeral: TFDQuery
    Connection = conn
    Left = 72
    Top = 136
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 160
    Top = 96
  end
end
