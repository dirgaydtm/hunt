lib/
├── main.dart                          # cuma runApp(), tipis
│
├── app/
│   ├── app.dart                       # root widget: MaterialApp.router()
│   └── config/
│       └── router.dart
│
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── network/
│   │   └── dio_client.dart            # instance Dio + interceptor, generic
│   ├── errors/
│   │   └── failures.dart
│   └── utils/
│       └── extensions.dart
│
├── features/
│   ├── onboarding/
│   ├── home/
│   └── feature-x/
│       ├── data/
│       │   ├── models/
│       │   │   └── feature_x_model.dart
│       │   ├── services/
│       │   │   └── feature_x_remote_datasource.dart   # panggil dio_client + endpoint
│       │   └── repositories/
│       │       └── feature_x_repository.dart          # konkret, langsung dipanggil provider
│       └── presentation/
│           ├── providers/
│           │   └── feature_x_provider.dart
│           ├── pages/
│           │   └── feature_x_page.dart
│           └── widgets/
│
└── shared/
    ├── models/
    └── widgets/

assets/
├── images/
└── icons/
