object DmUsuario: TDmUsuario
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 223
  Width = 396
  object TabUsuario: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 32
    Top = 136
  end
  object conn: TFDConnection
    AfterConnect = connAfterConnect
    BeforeConnect = connBeforeConnect
    Left = 32
    Top = 24
  end
  object QryGeral: TFDQuery
    Connection = conn
    Left = 200
    Top = 24
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 96
    Top = 24
  end
  object QryUsuario: TFDQuery
    Connection = conn
    Left = 264
    Top = 24
  end
  object TabPedido: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 120
    Top = 128
  end
end
