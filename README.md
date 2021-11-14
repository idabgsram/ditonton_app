[![Codemagic build status](https://api.codemagic.io/apps/617b756fa05d5ec5b323a0de/617b756fa05d5ec5b323a0dd/status_badge.svg)](https://codemagic.io/apps/617b756fa05d5ec5b323a0de/617b756fa05d5ec5b323a0dd/latest_build) [![codecov](https://codecov.io/gh/idabgsram/ditonton_app/branch/master/graph/badge.svg?token=WFN4DPWBDM)](https://codecov.io/gh/idabgsram/ditonton_app)

# Ditonton v1.0.1

a Project Improved by Ida Bagus Rama Mahendra

# Getting Started
Requires Flutter 2.5.3 or newer

# Task 
- [x] Add basic TV-related feature
- [x] TV Seasons & Episode feature
- [x] Continuous Integration
- [x] BLoC Migration
- [x] SSL Pinning
- [x] Firebase Analytics & Crashlytics Integration
- [x] Modularization
- [x] Widget Test
- [x] Basic Integration test
- [x] Testing Coverage +

# Build
type :
`flutter build`

# Running Project
type :
`flutter run`

# Testing
to run normal testing, type :
`flutter test modules/core modules/home modules/movies modules/search modules/tv_shows modules/watchlist --coverage`

to run universal coverage testing (linux or mac), type :
`./test-coverage.sh`

to generate lcov HTML, type :
`genhtml coverage/lcov.info -o coverage/html`

to run basic Integration Test :
`flutter drive --target=test_driver/app.dart` 