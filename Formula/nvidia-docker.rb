require "language/go"

class NvidiaDocker < Formula
  desc "Build and run Docker containers leveraging NVIDIA GPUs"
  homepage "https://github.com/NVIDIA/nvidia-docker"
  url "https://github.com/NVIDIA/nvidia-docker/archive/v1.0.1.tar.gz"
  sha256 "bb7cf057fadc5935c3ea2f7320516cae8feb8fc2421af9772e3127b258e38acd"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb76d7ddbed037bdf2fa560d4b7e2b1106336d368df08826dea6426a3ec812f1" => :sierra
    sha256 "0a8f1b16adeaa6d5b64fce4d8f6fe7fa2f4188dcc3b6d5ede19c623aa959290e" => :el_capitan
    sha256 "af6f3a3727f485d5f8af5e1759a16074a3de1556ad6736ef302d434c92e12681" => :yosemite
  end

  depends_on "go" => :build

  patch :p1, :DATA

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git",
        :revision => "adbae1b6b6fb4b02448a0fc0dbbc9ba2b95b294d"
  end

  def install
    ENV["GOPATH"] = buildpath/"go"

    (buildpath/"go/src/github.com/nvidia/nvidia-docker").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"go/src"

    cd("go/src/github.com/nvidia/nvidia-docker/src/nvidia-docker") do
      system "go", "build", "-o", bin/"nvidia-docker"
    end
  end

  test do
    system "#{bin}/nvidia-docker", "version"
  end
end

# git diff -U0
__END__
diff --git a/src/nvidia-docker/local.go b/src/nvidia-docker/local.go
index 8dc1736..be64480 100644
--- a/src/nvidia-docker/local.go
+++ b/src/nvidia-docker/local.go
@@ -2,0 +3,2 @@
+// +build !darwin
+
diff --git a/src/nvidia-docker/main.go b/src/nvidia-docker/main.go
index 956d0f6..ce316f2 100644
--- a/src/nvidia-docker/main.go
+++ b/src/nvidia-docker/main.go
@@ -14 +13,0 @@ import (
-	"github.com/NVIDIA/nvidia-docker/src/nvidia"
@@ -81,4 +79,0 @@ func main() {
-				assert(nvidia.LoadUVM())
-				assert(nvidia.Init())
-				nargs, err = GenerateLocalArgs(opt, vols)
-				nvidia.Shutdown()
