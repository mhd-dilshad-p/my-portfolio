# Deploying to Vercel

This guide will help you deploy your Flutter portfolio to Vercel.

## Prerequisites

- Node.js and npm installed
- Vercel account (free tier available)
- Vercel CLI installed globally: `npm install -g vercel`

## Deployment Steps

### Option 1: Using Vercel CLI (Recommended)

1. **Navigate to the project root directory**
   ```bash
   cd /Users/mohammeddilshadp/Desktop/Desk\ \ 1/IMOPRTANT/CodeX/portfolio
   ```

2. **Login to Vercel**
   ```bash
   vercel login
   ```

3. **Deploy the project**
   ```bash
   vercel
   ```

4. **Follow the prompts:**
   - Set up and deploy? **Y**
   - Which scope do you want to link to? **(select your account)**
   - Link to existing project? **N** (for first deployment)
   - Project name? **(press Enter for default or enter custom name)**
   - In which directory is your code located? **./portfolio_flutter**
   - Want to override the settings? **N** (the vercel.json will handle configuration)

5. **Deploy to production**
   ```bash
   vercel --prod
   ```

### Option 2: Using Vercel Dashboard

1. **Push your code to Git**
   - Push your repository to GitHub, GitLab, or Bitbucket

2. **Import project in Vercel Dashboard**
   - Go to [vercel.com](https://vercel.com)
   - Click "Add New Project"
   - Import your Git repository
   - Configure project:
     - **Framework Preset**: Other
     - **Root Directory**: `portfolio_flutter`
     - **Build Command**: `flutter build web --release`
     - **Output Directory**: `build/web`
     - **Install Command**: `flutter pub get`

3. **Deploy**
   - Click "Deploy"
   - Vercel will automatically build and deploy your project

## Configuration

The `vercel.json` file in the root directory contains the build configuration:

```json
{
  "buildCommand": "cd portfolio_flutter && flutter build web --release",
  "outputDirectory": "portfolio_flutter/build/web",
  "installCommand": "cd portfolio_flutter && flutter pub get"
}
```

## Custom Domain

After deployment:

1. Go to your project in Vercel Dashboard
2. Navigate to "Settings" → "Domains"
3. Add your custom domain
4. Update DNS records as instructed

## Continuous Deployment

Once connected to Git:
- Every push to the main branch will automatically deploy to production
- Pull request previews are automatically generated
- Rollback to previous deployments is available in the dashboard

## Troubleshooting

### Build fails with "Flutter not found"
Vercel doesn't have Flutter pre-installed. You need to use a custom runtime or build locally and deploy the `build/web` folder.

### Alternative: Deploy pre-built files

If you encounter issues with Flutter installation on Vercel:

1. **Build locally:**
   ```bash
   cd portfolio_flutter
   flutter build web --release
   ```

2. **Create a new project in Vercel:**
   - Move the contents of `build/web` to a separate folder or branch
   - Or configure Vercel to deploy from the `portfolio_flutter/build/web` directory

3. **Use Vercel's static site deployment:**
   ```bash
   cd portfolio_flutter/build/web
   vercel --prod
   ```

## Testing Locally

Preview your build locally before deploying:

```bash
cd portfolio_flutter
flutter build web --release
cd build/web
python3 -m http.server 8080
# Open http://localhost:8080 in your browser
```

Or use Vercel's local development:

```bash
vercel dev
```

## Links

- [Vercel Documentation](https://vercel.com/docs)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Vercel Pricing](https://vercel.com/pricing)
