require "language/go"

class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.16.0",
      :revision => "efa462daa2b961bff683677146713f4008555fba"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "df9065f3630a6b9fdc002c64d9e707adfa17da15772e05c778f62b394d024db2" => :sierra
    sha256 "9edffafe12d16da085097389e4a37db92e52be510a70b4372fd1c6450ede1b4c" => :el_capitan
    sha256 "760aecc7d3fad57c6e01e25016070dfc7f09b07d272411c4e7ee9db5fc272c9f" => :yosemite
  end

  devel do
    url "https://github.com/hashicorp/consul-template.git",
        :tag => "v0.18.0-rc1",
        :revision => "933192dc0b6bb642af2549848e0681670550e095"
    version "0.18.0-rc1"

    # Upstream issue "Request: Makefile target that doesn't use docker"
    # Reported 18 Nov 2016 https://github.com/hashicorp/consul-template/issues/793
    patch :DATA
  end

  head do
    url "https://github.com/hashicorp/consul-template.git"

    patch :DATA
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "c9740af9c6574448fd48eb30a71f964014c7a837"
  end

  # gox dependency
  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/hashicorp/consul-template"
    dir.install buildpath.children

    Language::Go.stage_deps resources, buildpath/"src"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    cd("src/github.com/mitchellh/gox") { system "go", "install" }

    cd dir do
      system "make", "dev"
      system "make", "test"
    end

    bin.install "bin/consul-template"
  end

  test do
    (testpath/"template").write <<-EOS.undent
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end

__END__
diff --git a/Makefile b/Makefile
index 4d5304c..917fb7b 100644
--- a/Makefile
+++ b/Makefile
@@ -35,19 +35,16 @@ GOFILES = $(shell go list $(TEST) | grep -v /vendor/)
 # environment variables.
 bin:
 	@echo "==> Building ${PROJECT}..."
-	@docker run \
-		--rm \
-		--env="VERSION=${VERSION}" \
-		--env="PROJECT=${PROJECT}" \
-		--env="OWNER=${OWNER}" \
-		--env="NAME=${NAME}" \
-		--env="XC_OS=${XC_OS}" \
-		--env="XC_ARCH=${XC_ARCH}" \
-		--env="XC_EXCLUDE=${XC_EXCLUDE}" \
-		--env="DIST=${DIST}" \
-		--workdir="/go/src/${PROJECT}" \
-		--volume="${CURRENT_DIR}:/go/src/${PROJECT}" \
-		"golang:${GOVERSION}" /bin/sh -c "scripts/compile.sh"
+	env \
+		VERSION="${VERSION}" \
+		PROJECT="${PROJECT}" \
+		OWNER="${OWNER}" \
+		NAME="${NAME}" \
+		XC_OS="${XC_OS}" \
+		XC_ARCH="${XC_ARCH}" \
+		XC_EXCLUDE="${XC_EXCLUDE}" \
+		DIST="${DIST}" \
+		sh -c "'${CURDIR}/scripts/compile.sh'"
 
 # bootstrap installs the necessary go tools for development or build
 bootstrap:
