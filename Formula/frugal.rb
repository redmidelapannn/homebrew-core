class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.9.0.tar.gz"
  sha256 "161db88530e2c9450370f8d9ac43ec6f03a630bb2c3e1f6edd84fd5886999f22"

  bottle do
    cellar :any_skip_relocation
    sha256 "93020144f642af9c1a38165aa3327073e4c1b803a46db30584279179d055e6a8" => :catalina
    sha256 "52b52918d9394bf8dd725623be1436635b4ec8ca3a8adb7e3ebcc561dc80ec93" => :mojave
    sha256 "c16e56804f121892b086ba5e9919179b00adb75a260e08702d17a53dcf70e5e4" => :high_sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd "src/github.com/Workiva/frugal" do
      system "glide", "install"
      system "go", "build", "-o", bin/"frugal"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
