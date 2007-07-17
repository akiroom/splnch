object frmMain: TfrmMain
  Left = 463
  Top = 379
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Special Launch '#12475#12483#12488#12450#12483#12503
  ClientHeight = 339
  ClientWidth = 523
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 523
    Height = 293
    ActivePage = tabSL4UserFolder
    Align = alTop
    Style = tsButtons
    TabHeight = 10
    TabOrder = 0
    OnChange = PageControlChange
    object tabStart: TTabSheet
      Caption = 'tabStart'
      ImageIndex = 3
      object imgIcon: TImage
        Left = 20
        Top = 24
        Width = 32
        Height = 32
      end
      object lblTitle: TLabel
        Left = 88
        Top = 28
        Width = 205
        Height = 16
        Caption = 'Special Launch '#12475#12483#12488#12450#12483#12503
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = [fsBold]
        ParentFont = False
      end
      object rdoInstall: TRadioButton
        Left = 148
        Top = 152
        Width = 257
        Height = 17
        Caption = 'Special Launch '#12434#12452#12531#12473#12488#12540#12523#12377#12427'(&I)'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object rdoConvert: TRadioButton
        Left = 148
        Top = 172
        Width = 313
        Height = 17
        Caption = #21069#12496#12540#12472#12519#12531#12398#12508#12479#12531#12501#12449#12452#12523#12434#12467#12531#12496#12540#12488#12377#12427'(&C)'
        TabOrder = 1
      end
      object rdoUninstall: TRadioButton
        Left = 148
        Top = 192
        Width = 309
        Height = 17
        Caption = 'Special Launch '#12434#12467#12531#12500#12517#12540#12479#12363#12425#21066#38500#12377#12427'(&U)'
        TabOrder = 2
      end
      object memDescription: TMemo
        Left = 140
        Top = 72
        Width = 349
        Height = 73
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 3
        WantReturns = False
      end
    end
    object tabTargetFolder: TTabSheet
      Caption = 'tabTargetFolder'
      ImageIndex = 4
      object lblTargetFolder: TLabel
        Left = 10
        Top = 40
        Width = 357
        Height = 12
        Caption = 'Special Launch '#12434#12452#12531#12473#12488#12540#12523#12377#12427#12501#12457#12523#12480#12434#25351#23450#12375#12390#12367#12384#12373#12356#12290
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 68
        Top = 112
        Width = 135
        Height = 12
        Caption = #12452#12531#12473#12488#12540#12523#20808#12501#12457#12523#12480'(&F):'
        FocusControl = edtTargetFolder
      end
      object edtTargetFolder: TEdit
        Left = 88
        Top = 132
        Width = 397
        Height = 20
        TabOrder = 0
      end
      object btnTargetFolder: TButton
        Left = 412
        Top = 164
        Width = 75
        Height = 25
        Caption = #21442#29031'(&B)...'
        TabOrder = 1
        OnClick = btnTargetFolderClick
      end
    end
    object tabInstallOptions: TTabSheet
      Caption = 'tabInstallOptions'
      ImageIndex = 5
      object lblInstallOptions: TLabel
        Left = 10
        Top = 40
        Width = 248
        Height = 12
        Caption = #12452#12531#12473#12488#12540#12523#12398#12458#12503#12471#12519#12531#12434#25351#23450#12375#12390#12367#12384#12373#12356#12290
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 84
        Top = 196
        Width = 401
        Height = 12
        Caption = #8251#65339#12503#12525#12464#12521#12512#12398#36861#21152#12392#21066#38500#65341#12408#12398#30331#37682#12395#12399#12524#12472#12473#12488#12522#12398#30331#37682#12364#24517#35201#12395#12394#12426#12414#12377#12290
      end
      object chkProgramMenu: TCheckBox
        Left = 68
        Top = 93
        Width = 195
        Height = 17
        Caption = #12503#12525#12464#12521#12512#12513#12491#12517#12540#12395#30331#37682#12377#12427'(&S)'
        TabOrder = 0
      end
      object chkStartup: TCheckBox
        Left = 68
        Top = 116
        Width = 293
        Height = 17
        Caption = 'Windows '#12398#36215#21205#26178#12395' Special Launch '#12418#36215#21205#12377#12427'(&R)'
        TabOrder = 1
      end
      object chkRegistry: TCheckBox
        Left = 68
        Top = 173
        Width = 349
        Height = 17
        Caption = #12467#12531#12488#12525#12540#12523#12497#12493#12523#12398#65339#12503#12525#12464#12521#12512#12398#36861#21152#12392#21066#38500#65341#12395#30331#37682#12377#12427'(&U)'
        TabOrder = 3
      end
      object chkDesktop: TCheckBox
        Left = 68
        Top = 139
        Width = 245
        Height = 17
        Caption = #12487#12473#12463#12488#12483#12503#12395#12471#12519#12540#12488#12459#12483#12488#12434#20316#25104#12377#12427'(&D)'
        TabOrder = 2
      end
    end
    object tabSL4UserFolder: TTabSheet
      Caption = 'tabSL4UserFolder'
      ImageIndex = 1
      object lblSL4UserFolder: TLabel
        Left = 10
        Top = 40
        Width = 270
        Height = 12
        Caption = #21508#31278#35373#23450#12434#20445#23384#12377#12427#12501#12457#12523#12480#12434#25351#23450#12375#12390#12367#12384#12373#12356#12290
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 68
        Top = 172
        Width = 93
        Height = 12
        Caption = #12487#12540#12479#12501#12457#12523#12480'(&F):'
        FocusControl = edtSL4UserFolder
      end
      object lblSL4UserFolderInfo: TLabel
        Left = 68
        Top = 88
        Width = 397
        Height = 36
        Caption = 
          #12508#12479#12531#31561#12398#21508#31278#35373#23450#12434#20445#23384#12377#12427#12501#12457#12523#12480#12434#25351#23450#12375#12390#12367#12384#12373#12356#12290#13#12371#12398#12501#12457#12523#12480#12434#12496#12483#12463#12450#12483#12503#12377#12427#12371#12392#12391' Special Launch '#12398 +
          #35373#23450#12434#24489#26087#12377#12427#12371#12392#12364#13#12391#12365#12414#12377#12290
      end
      object edtSL4UserFolder: TEdit
        Left = 88
        Top = 192
        Width = 397
        Height = 20
        TabOrder = 1
        OnChange = edtSL4UserFolderChange
      end
      object btnSL4UserFolder: TButton
        Left = 410
        Top = 218
        Width = 75
        Height = 25
        Caption = #21442#29031'(&B)...'
        TabOrder = 2
        OnClick = btnSL4UserFolderClick
      end
      object chkSettingForAllUser: TCheckBox
        Left = 68
        Top = 141
        Width = 245
        Height = 17
        Caption = #12377#12409#12390#12398#12518#12540#12470#12540#12391#21516#12376#35373#23450#12434#20351#12358'(&A)'
        TabOrder = 0
        OnClick = chkSettingForAllUserClick
      end
    end
    object tabSL3Groups: TTabSheet
      Caption = 'tabSL3Groups'
      object lblSL3Groups: TLabel
        Left = 10
        Top = 40
        Width = 406
        Height = 12
        Caption = 'Special Launch 3 '#12363#12425#12467#12531#12496#12540#12488#12377#12427#12508#12479#12531#12464#12523#12540#12503#12434#36984#25246#12375#12390#12367#12384#12373#12356#12290
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Image1: TImage
        Left = 8
        Top = 72
        Width = 32
        Height = 32
        AutoSize = True
        Picture.Data = {
          055449636F6E0000010003001010100000000000280100003600000020201000
          00000000E80200005E0100002020000000000000A80800004604000028000000
          10000000200000000100040000000000C0000000000000000000000000000000
          0000000000000000000080000080000000808000800000008000800080800000
          80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
          FFFFFF0000000000000000000070777777777700007F888888888870007F8888
          888888700077778888888870CCCCCC7888888870CEE6CC08888888707F707078
          8888887078F780788888887007F7078888888870007078888888887007870788
          888888707F70708FFFFFFF707FF8807777777770CCCCCC0000000000CEE6CC00
          00000000E0010000C0000000C0000000C0000000C00000000000000000000000
          000000000000000080000000C000000080000000000000000001000003FF0000
          03FF000028000000200000004000000001000400000000008002000000000000
          0000000000000000000000000000000000008000008000000080800080000000
          800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000
          FF00FF00FFFF0000FFFFFF000000000000000000000000000000000000008777
          7777777777777777777000000008887777777777777777777777000000888888
          88888888888888888877700000F8888888888888888888888887770000FF8888
          88888888888888888888770000FF888888888888888888888888770000FF8888
          88888888888888888888770000FF888888888888888888888888770000FF8888
          88888888888888888888770000FF787878787888888888888888770000F77777
          77777788888888888888770000CCCCCCCCCCC778888888888888770000C6EEEE
          6666C788888888888888770000FCCCCCCCCC7788888888888888770000F08080
          80807888888888888888770000F08F0808807788888888888888770000F08FF0
          F8807888888888888888770000F08FFFF8808888888888888888770000FF08FF
          88088888888888888888770000FF808F80788888888888888888770000FF8800
          07788888888888888888770000FF880807788888888888888888770000FF8080
          807788888888888888887700008F080808078888888888888888870000808080
          80807888888888888888880000008FFF888088FFFFFFFFFFFF88800000008FFF
          888088FFFFFFFFFFFFF8000000008FFF888077000000000000000000000CCCCC
          CCCC0000000000000000000000C6EEEE6666C000000000000000000000CCCCCC
          CCCCC0000000000000000000F000000FE0000007C00000038000000180000001
          8000000180000001800000018000000180000001800000018000000180000001
          8000000180000001800000018000000180000001800000018000000180000001
          8000000180000001800000018000000180000001C0000003E0000007E000000F
          E00FFFFFC007FFFFC007FFFF2800000020000000400000000100080000000000
          8004000000000000000000000000000000000000000000000000800000800000
          00808000800000008000800080800000C0C0C000C0DCC000F0CAA600D4F0FF00
          B1E2FF008ED4FF006BC6FF0048B8FF0025AAFF0000AAFF000092DC00007AB900
          00629600004A730000325000D4E3FF00B1C7FF008EABFF006B8FFF004873FF00
          2557FF000055FF000049DC00003DB900003196000025730000195000D4D4FF00
          B1B1FF008E8EFF006B6BFF004848FF002525FF000000FE000000DC000000B900
          000096000000730000005000E3D4FF00C7B1FF00AB8EFF008F6BFF007348FF00
          5725FF005500FF004900DC003D00B900310096002500730019005000F0D4FF00
          E2B1FF00D48EFF00C66BFF00B848FF00AA25FF00AA00FF009200DC007A00B900
          620096004A00730032005000FFD4FF00FFB1FF00FF8EFF00FF6BFF00FF48FF00
          FF25FF00FE00FE00DC00DC00B900B900960096007300730050005000FFD4F000
          FFB1E200FF8ED400FF6BC600FF48B800FF25AA00FF00AA00DC009200B9007A00
          9600620073004A0050003200FFD4E300FFB1C700FF8EAB00FF6B8F00FF487300
          FF255700FF005500DC004900B9003D00960031007300250050001900FFD4D400
          FFB1B100FF8E8E00FF6B6B00FF484800FF252500FE000000DC000000B9000000
          960000007300000050000000FFE3D400FFC7B100FFAB8E00FF8F6B00FF734800
          FF572500FF550000DC490000B93D0000963100007325000050190000FFF0D400
          FFE2B100FFD48E00FFC66B00FFB84800FFAA2500FFAA0000DC920000B97A0000
          96620000734A000050320000FFFFD400FFFFB100FFFF8E00FFFF6B00FFFF4800
          FFFF2500FEFE0000DCDC0000B9B90000969600007373000050500000F0FFD400
          E2FFB100D4FF8E00C6FF6B00B8FF4800AAFF2500AAFF000092DC00007AB90000
          629600004A73000032500000E3FFD400C7FFB100ABFF8E008FFF6B0073FF4800
          57FF250055FF000049DC00003DB90000319600002573000019500000D4FFD400
          B1FFB1008EFF8E006BFF6B0048FF480025FF250000FE000000DC000000B90000
          009600000073000000500000D4FFE300B1FFC7008EFFAB006BFF8F0048FF7300
          25FF570000FF550000DC490000B93D00009631000073250000501900D4FFF000
          B1FFE2008EFFD4006BFFC60048FFB80025FFAA0000FFAA0000DC920000B97A00
          0096620000734A0000503200D4FFFF00B1FFFF008EFFFF006BFFFF0048FFFF00
          25FFFF0000FEFE0000DCDC0000B9B900009696000073730000505000F2F2F200
          E6E6E600DADADA00CECECE00C2C2C200B6B6B600AAAAAA009E9E9E0092929200
          868686007A7A7A006E6E6E0062626200565656004A4A4A003E3E3E0032323200
          262626001A1A1A000E0E0E00F0FBFF00A4A0A000808080000000FF0000FF0000
          00FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000EEEFF5F5F5F5F5F5
          F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F500000000000000EDEEEEEEEEEEEEEEEE
          EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEF50000000000EDE9E9E9E9E9E9E9E9E9
          E9E9E9E9E9E9E9E9E9E9E9E9E9E9F8F8EEF5000000EAE907E807070707070707
          0707070707070707070707070707E9F8F8EEF50000EAE3E40707070707070707
          070707070707070707070707070707E9F8EEF50000EAFFE30707070707070707
          07070707070707070707070707070707E9EEF50000EAFFE30707070707070707
          07070707070707070707070707070707E9EEF50000EAFFE30707070707070707
          07070707070707070707070707070707E9EEF50000EAFFE30707070707070707
          07070707070707070707070707070707E9EEF50000EAFFE30707070707070707
          07070707070707070707070707070707E9EEF50000EAFFE50707070707070707
          07070707070707070707070707070707E9EEF50000EAFFEAEAEAEAEAEAEAEAEA
          EAEA0707070707070707070707070707E9EEF50000EA716E79787778796E7172
          73EA0707070707070707070707070707E9EEF50000EA71888695829586888A8B
          73EA0707070707070707070707070707E9EEF50000EAFF6E79787778796E7172
          E8070707070707070707070707070707E9EEF50000EAFFE5E9EAE6EDEBEDEAEE
          E8070707070707070707070707070707E9EEF50000EAFFE5E2E5E9E8EDE9EAEE
          E8070707070707070707070707070707E9EEF50000EAE2E5E2E2E5E9E9E8EAEE
          E8070707070707070707070707070707E9EEF50000EAE2E3E2E2E2E8E6E8EAEE
          07070707070707070707070707070707E9EEF50000EAE2E3E5E2E2E4E6E8EE07
          07070707070707070707070707070707E9EEF50000EAE2E3E5E5E2E4E6E8EE07
          07070707070707070707070707070707E9EEF50000EAE2E307E5E5EAE6EEE807
          07070707070707070707070707070707E9EEF50000EAE2E307E5E9E7EEF8E8E8
          07070707070707070707070707070707E9EEF50000EAE2E307E5E9E4EEEDF8E8
          E8070707070707070707070707070707E9EEF50000EAE2E3E5E9E4E9EBEEEAF8
          E8070707070707070707070707070707E9EEF00000EAE2E5E9E4E4E4E9EBEEEC
          E8E5E5E5E5E5E5E5E5E5E5E5E5E5E5E6E8EEEE000000EAE5E4E2E2E4E6E8EAEE
          E8E3E3E3E3E3E3E3E3E3E3E3E3E3E4E7E8ED0000000000E5E4E2E2E4E6E8EAEE
          E807FFFFFFFFFFFFFFFFFFFFFFFFFFE6EA000000000000E5E4E2E2E4E6E8EAEE
          EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA000000000000006E79787778796E7172
          E800000000000000000000000000000000000000000071888695769586888A8B
          73E80000000000000000000000000000000000000000716E79786B78796E7172
          73E8000000000000000000000000000000000000F000000FE0000007C0000003
          8000000180000001800000018000000180000001800000018000000180000001
          8000000180000001800000018000000180000001800000018000000180000001
          80000001800000018000000180000001800000018000000180000001C0000003
          E0000007E000000FE007FFFFC003FFFFC003FFFF}
      end
      object lvSL3Groups: TListView
        Left = 56
        Top = 72
        Width = 445
        Height = 153
        Checkboxes = True
        Columns = <
          item
            Caption = #12464#12523#12540#12503#21517
            Width = 200
          end
          item
            Caption = #12508#12479#12531#12501#12449#12452#12523#21517
            Width = 200
          end>
        ColumnClick = False
        HideSelection = False
        TabOrder = 0
        ViewStyle = vsReport
      end
      object lvSL3GroupsAllYes: TButton
        Left = 348
        Top = 232
        Width = 75
        Height = 25
        Caption = #20840#36984#25246'(&A)'
        TabOrder = 1
        OnClick = lvSL3GroupsAllYesClick
      end
      object lvSL3GroupsAllNo: TButton
        Left = 428
        Top = 232
        Width = 75
        Height = 25
        Caption = #20840#35299#38500'(&N)'
        TabOrder = 2
        OnClick = lvSL3GroupsAllNoClick
      end
    end
    object tabUninstallOptions: TTabSheet
      Caption = 'tabUninstallOptions'
      ImageIndex = 6
      object lblUninstallOptions: TLabel
        Left = 10
        Top = 40
        Width = 271
        Height = 12
        Caption = #12450#12531#12452#12531#12473#12488#12540#12523#12398#12458#12503#12471#12519#12531#12434#25351#23450#12375#12390#12367#12384#12373#12356#12290
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = [fsBold]
        ParentFont = False
      end
      object chkDeleteData: TCheckBox
        Left = 68
        Top = 96
        Width = 321
        Height = 17
        Caption = #21508#12518#12540#12470#12540#12398#12487#12540#12479#12501#12457#12523#12480#12434#21066#38500#12377#12427'(&D)'
        TabOrder = 0
      end
      object chkDeletePlugins: TCheckBox
        Left = 68
        Top = 116
        Width = 281
        Height = 17
        Caption = #12503#12521#12464#12452#12531#12501#12457#12523#12480#12434#21066#38500#12377#12427'(&P)'
        TabOrder = 1
      end
    end
    object tabInfo: TTabSheet
      Caption = 'tabInfo'
      ImageIndex = 2
      OnShow = tabInfoShow
      object lblInfo: TLabel
        Left = 10
        Top = 4
        Width = 147
        Height = 12
        Caption = #20197#19979#12398#35373#23450#12391#23455#34892#12375#12414#12377#12290
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = [fsBold]
        ParentFont = False
      end
      object memInfo: TMemo
        Left = 16
        Top = 24
        Width = 485
        Height = 253
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WantReturns = False
      end
    end
  end
  object btnPrev: TButton
    Left = 190
    Top = 299
    Width = 75
    Height = 21
    Caption = #25147#12427'(&P)'
    TabOrder = 1
    OnClick = btnPrevClick
  end
  object btnNext: TButton
    Left = 271
    Top = 299
    Width = 75
    Height = 21
    Caption = #27425#12408'(&N)'
    TabOrder = 2
    OnClick = btnNextClick
  end
  object btnCancel: TButton
    Left = 433
    Top = 299
    Width = 75
    Height = 21
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object btnRun: TButton
    Left = 352
    Top = 299
    Width = 75
    Height = 21
    Caption = #23455#34892'(&R)'
    TabOrder = 3
    OnClick = btnRunClick
  end
  object XPManifest1: TXPManifest
    Left = 112
    Top = 300
  end
end
