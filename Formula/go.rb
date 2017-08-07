class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://golang.org"

  stable do
    url "https://storage.googleapis.com/golang/go1.8.3.src.tar.gz"
    mirror "https://fossies.org/linux/misc/go1.8.3.src.tar.gz"
    version "1.8.3"
    sha256 "5f5dea2447e7dcfdc50fa6b94c512e58bfba5673c039259fd843f68829d99fa6"

    go_version = version.to_s.split(".")[0..1].join(".")
    resource "gotools" do
      url "https://go.googlesource.com/tools.git",
          :branch => "release-branch.go#{go_version}"
    end
  end

  bottle do
    rebuild 1
    sha256 "14b4c5bf246a4660df15bca0d45af8e1bfb7fa5ec0600b552f58a11ef5f4a6a6" => :sierra
    sha256 "7f600d70b28e4d1045f21413339b01b62f138bb686dd4786731beae251cbb616" => :el_capitan
    sha256 "d081e7b6ed8c914df24dec8bb955f1116d91fc9e59e490a2841266ad88211f65" => :yosemite
  end

  devel do
    url "https://storage.googleapis.com/golang/go1.9rc2.src.tar.gz"
    sha256 "12b09ea6cb3189ea5e4c057f7047b5709ae8edd14706421b188f7e4ae8d8d3e4"

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

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    url "https://storage.googleapis.com/golang/go1.7.darwin-amd64.tar.gz"
    version "1.7"
    sha256 "51d905e0b43b3d0ed41aaf23e19001ab4bc3f96c3ca134b48f7892485fc52961"
  end

  def install
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
    A valid GOPATH is required to use the `go get` command.
    If $GOPATH is not specified, $HOME/go will be used by default:
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
