class Go < Formula
  desc "The Go programming language"
  homepage "https://golang.org"
  revision 2

  stable do
    url "https://storage.googleapis.com/golang/go1.7.4.src.tar.gz"
    mirror "https://fossies.org/linux/misc/go1.7.4.src.tar.gz"
    version "1.7.4"
    sha256 "4c189111e9ba651a2bb3ee868aa881fab36b2f2da3409e80885ca758a6b614cc"

    go_version = version.to_s.split(".")[0..1].join(".")
    resource "gotools" do
      url "https://go.googlesource.com/tools.git",
          :branch => "release-branch.go#{go_version}",
          :revision => "26c35b4dcf6dfcb924e26828ed9f4d028c5ce05a"
    end

    # Upstream commit from 14 Dec 2016 "crypto/x509: speed up and deflake
    # non-cgo Darwin root cert discovery"
    patch do
      url "https://github.com/golang/go/commit/3357daa.patch"
      sha256 "c3945cacd5a208cf0bbd6125c77665ef1829035ae09133f3fd50e1022e0f2032"
    end
  end

  bottle do
    rebuild 1
    sha256 "e40dc9051f1cfb7b5be42a6ff62c7ee5b03ba55db5e4c59fd9a0ac65f7a1b530" => :sierra
    sha256 "2145c440db573482376f6ab6e5d4e823ce5ac2cc394ccbb10072ef7bd4cd3183" => :el_capitan
    sha256 "ae3608ec358a68a5a3e017531df53d94aa6d4c62772a4d5885fe1e38468a4019" => :yosemite
  end

  devel do
    url "https://storage.googleapis.com/golang/go1.8rc3.src.tar.gz"
    version "1.8rc3"
    sha256 "38b1c1738f111f7bccdd372efca2aa98a7bad1ca2cb21767ba69f34ae007499c"

    resource "gotools" do
      url "https://go.googlesource.com/tools.git"
    end
  end

  head do
    url "https://go.googlesource.com/go.git"

    resource "gotools" do
      url "https://go.googlesource.com/tools.git"
    end
  end

  option "without-cgo", "Build without cgo (also disables race detector)"
  option "without-godoc", "godoc will not be installed for you"
  option "without-race", "Build without race detector"

  depends_on :macos => :mountain_lion

  # Should use the last stable binary release to bootstrap.
  # More explicitly, leave this at 1.7 when 1.7.1 is released.
  resource "gobootstrap" do
    url "https://storage.googleapis.com/golang/go1.7.darwin-amd64.tar.gz"
    version "1.7"
    sha256 "51d905e0b43b3d0ed41aaf23e19001ab4bc3f96c3ca134b48f7892485fc52961"
  end

  def install
    ENV.permit_weak_imports

    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      ENV["GOOS"]         = "darwin"
      ENV["CGO_ENABLED"]  = "0" if build.without?("cgo")
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    # Race detector only supported on amd64 platforms.
    # https://golang.org/doc/articles/race_detector.html
    if build.with?("cgo") && build.with?("race") && MacOS.prefer_64_bit?
      system bin/"go", "install", "-race", "std"
    end

    if build.with? "godoc"
      ENV.prepend_path "PATH", bin
      ENV["GOPATH"] = buildpath
      (buildpath/"src/golang.org/x/tools").install resource("gotools")

      if build.with? "godoc"
        cd "src/golang.org/x/tools/cmd/godoc/" do
          system "go", "build"
          (libexec/"bin").install "godoc"
        end
        bin.install_symlink libexec/"bin/godoc"
      end
    end
  end

  def caveats; <<-EOS.undent
    As of go 1.2, a valid GOPATH is required to use the `go get` command:
      https://golang.org/doc/code.html#GOPATH

    You may wish to add the GOROOT-based install location to your PATH:
      export PATH=$PATH:#{opt_libexec}/bin
    EOS
  end

  test do
    (testpath/"hello.go").write <<-EOS.undent
    package main

    import "fmt"

    func main() {
        fmt.Println("Hello World")
    }
    EOS
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    if build.with? "godoc"
      assert File.exist?(libexec/"bin/godoc")
      assert File.executable?(libexec/"bin/godoc")
    end

    if build.with? "cgo"
      ENV["GOOS"] = "freebsd"
      system bin/"go", "build", "hello.go"
    end
  end
end
