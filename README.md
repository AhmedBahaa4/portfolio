# Portfolio

Professional Flutter portfolio (web) with clean architecture.

## Run locally

- `flutter pub get`
- `flutter run -d chrome`

## Test on phone (same Wi‑Fi)
Run a web server build and open it from your phone:
- `flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080`
- On your phone open: `http://<YOUR_PC_LAN_IP>:8080`

## Update your content

All portfolio data comes from `assets/data/portfolio.json`.

### Add a new project
1. Open `assets/data/portfolio.json`
2. Append a new object to the `projects` array (same shape as the existing ones)
3. (Optional) Add an image to `assets/images/` and set `imageAsset` to something like:
   - `"imageAsset": "assets/images/my_project.png"`

### Add a CV (PDF download)
1. Put your PDF inside `assets/files/` (example: `assets/files/cv.pdf`)
2. Update `assets/data/portfolio.json`:
   - `"cvUrl": "assets/files/cv.pdf"`
3. Hot restart / rerun the app

### Add your photo
1. Put your image inside `assets/images/` (example: `assets/images/my.jpg`)
2. Update `assets/data/portfolio.json`:
   - `"avatarAsset": "assets/images/my.jpg"`

## Deploy (web)
- `flutter build web --release`
- Upload `build/web/` to your hosting provider
