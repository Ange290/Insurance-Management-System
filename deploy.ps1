$projectPath = "D:\Backend_Using_Java\InsuranceManagementSystem"
$tomcatPath = "C:\tomcat"
$appPath = "$tomcatPath\webapps\InsuranceManagementSystem"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Deploying Insurance Management System" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Check if IntelliJ compiled the classes
if (Test-Path "$projectPath\target\classes\com\insurance") {
    Write-Host "[OK] Compiled classes found in target\classes" -ForegroundColor Green
    $useExisting = $true
} else {
    Write-Host "[!] No compiled classes found." -ForegroundColor Red
    Write-Host "Please compile in IntelliJ: Build -> Build Project (Ctrl+F9)" -ForegroundColor Yellow
    pause
    exit
}

# Deploy to Tomcat
Write-Host "`nDeploying to Tomcat..." -ForegroundColor Yellow

# Remove existing deployment if exists
if (Test-Path $appPath) {
    Write-Host "  - Removing old deployment..."
    Remove-Item -Path $appPath -Recurse -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

# Create directories
New-Item -ItemType Directory -Force -Path "$appPath\WEB-INF\classes" | Out-Null
New-Item -ItemType Directory -Force -Path "$appPath\WEB-INF\lib" | Out-Null

# Copy web resources (JSP, HTML, CSS, etc.)
Write-Host "  - Copying web resources..."
if (Test-Path "$projectPath\src\main\webapp\WEB-INF") {
    Copy-Item -Path "$projectPath\src\main\webapp\WEB-INF" -Destination "$appPath\" -Recurse -Force -ErrorAction SilentlyContinue
}
if (Test-Path "$projectPath\src\main\webapp\*.jsp") {
    Copy-Item -Path "$projectPath\src\main\webapp\*.jsp" -Destination "$appPath\" -Force -ErrorAction SilentlyContinue
}

# Copy compiled classes
Write-Host "  - Copying compiled classes..."
Copy-Item -Path "$projectPath\target\classes\*" -Destination "$appPath\WEB-INF\classes\" -Recurse -Force

# Copy database.properties
if (Test-Path "$projectPath\src\main\resources") {
    Write-Host "  - Copying resources..."
    Copy-Item -Path "$projectPath\src\main\resources\*" -Destination "$appPath\WEB-INF\classes\" -Recurse -Force -ErrorAction SilentlyContinue
}

# Copy MySQL JAR
Write-Host "  - Copying MySQL connector..."
$mysqlJar = "C:\Users\User\.m2\repository\com\mysql\mysql-connector-j\8.3.0\mysql-connector-j-8.3.0.jar"
if (Test-Path $mysqlJar) {
    Copy-Item -Path $mysqlJar -Destination "$appPath\WEB-INF\lib\" -Force
    Write-Host "    [OK] MySQL connector copied" -ForegroundColor Green
} else {
    Write-Host "    [WARNING] MySQL JAR not found at: $mysqlJar" -ForegroundColor Red
}

# Copy JSTL Implementation JAR
Write-Host "  - Copying JSTL Implementation..."
$jstlImplJar = "C:\Users\User\.m2\repository\org\glassfish\web\jakarta.servlet.jsp.jstl\3.0.1\jakarta.servlet.jsp.jstl-3.0.1.jar"
if (Test-Path $jstlImplJar) {
    Copy-Item -Path $jstlImplJar -Destination "$appPath\WEB-INF\lib\" -Force
    Write-Host "    [OK] JSTL Implementation copied" -ForegroundColor Green
} else {
    Write-Host "    [!] Downloading JSTL Implementation..." -ForegroundColor Yellow
    $jstlImplUrl = "https://repo1.maven.org/maven2/org/glassfish/web/jakarta.servlet.jsp.jstl/3.0.1/jakarta.servlet.jsp.jstl-3.0.1.jar"
    try {
        Invoke-WebRequest -Uri $jstlImplUrl -OutFile "$appPath\WEB-INF\lib\jakarta.servlet.jsp.jstl-3.0.1.jar"
        Write-Host "    [OK] JSTL Implementation downloaded" -ForegroundColor Green
    } catch {
        Write-Host "    [ERROR] Could not download JSTL Implementation" -ForegroundColor Red
    }
}

# Copy JSTL API JAR
Write-Host "  - Copying JSTL API..."
$jstlApiJar = "C:\Users\User\.m2\repository\jakarta\servlet\jsp\jstl\jakarta.servlet.jsp.jstl-api\3.0.1\jakarta.servlet.jsp.jstl-api-3.0.1.jar"
if (Test-Path $jstlApiJar) {
    Copy-Item -Path $jstlApiJar -Destination "$appPath\WEB-INF\lib\" -Force
    Write-Host "    [OK] JSTL API copied" -ForegroundColor Green
} else {
    Write-Host "    [!] Downloading JSTL API..." -ForegroundColor Yellow
    $jstlApiUrl = "https://repo1.maven.org/maven2/jakarta/servlet/jsp/jstl/jakarta.servlet.jsp.jstl-api/3.0.1/jakarta.servlet.jsp.jstl-api-3.0.1.jar"
    try {
        Invoke-WebRequest -Uri $jstlApiUrl -OutFile "$appPath\WEB-INF\lib\jakarta.servlet.jsp.jstl-api-3.0.1.jar"
        Write-Host "    [OK] JSTL API downloaded" -ForegroundColor Green
    } catch {
        Write-Host "    [ERROR] Could not download JSTL API" -ForegroundColor Red
    }
}

# Verify deployment
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "VERIFYING DEPLOYMENT" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$checks = @{
    "Java Classes" = "$appPath\WEB-INF\classes\com\insurance"
    "MySQL JAR" = "$appPath\WEB-INF\lib\mysql-connector-j-8.3.0.jar"
    "JSTL Implementation" = "$appPath\WEB-INF\lib\jakarta.servlet.jsp.jstl-3.0.1.jar"
    "JSTL API" = "$appPath\WEB-INF\lib\jakarta.servlet.jsp.jstl-api-3.0.1.jar"
    "login.jsp" = "$appPath\WEB-INF\views\login.jsp"
}

$allOk = $true
foreach ($item in $checks.GetEnumerator()) {
    if (Test-Path $item.Value) {
        Write-Host "  [OK] $($item.Key)" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $($item.Key)" -ForegroundColor Red
        $allOk = $false
    }
}

if ($allOk) {
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "DEPLOYMENT SUCCESSFUL!" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Green

    Write-Host "Application deployed to:" -ForegroundColor Cyan
    Write-Host "  $appPath`n" -ForegroundColor White

    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Restart Tomcat:"
    Write-Host "     C:\tomcat\bin\shutdown.bat"
    Write-Host "     C:\tomcat\bin\startup.bat"
    Write-Host "  2. Wait 10-15 seconds for deployment"
    Write-Host "  3. Open browser: http://localhost:8080/InsuranceManagementSystem/login"
    Write-Host "  4. Login with: admin@insurance.com / admin123`n"

    Write-Host "Deployed JARs:" -ForegroundColor Cyan
    Get-ChildItem "$appPath\WEB-INF\lib\*.jar" | Select-Object Name, @{Name="Size (KB)";Expression={[math]::Round($_.Length/1KB,2)}}
} else {
    Write-Host "`n========================================" -ForegroundColor Red
    Write-Host "DEPLOYMENT INCOMPLETE!" -ForegroundColor Red
    Write-Host "========================================`n" -ForegroundColor Red
    Write-Host "Please check errors above." -ForegroundColor Yellow
}

pause