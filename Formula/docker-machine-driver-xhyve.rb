class DockerMachineDriverXhyve < Formula
  desc "Docker Machine driver for xhyve"
  homepage "https://github.com/zchee/docker-machine-driver-xhyve"
  url "https://github.com/zchee/docker-machine-driver-xhyve.git",
    :tag => "v0.3.2",
    :revision => "c290fd6efa3891782b023001e96cf8c8827d31e0"

  head "https://github.com/zchee/docker-machine-driver-xhyve.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9c72b2d36af77709dda797c33c0d37bad7f199eccfb82258bcdb2b7e53c1f0f7" => :sierra
    sha256 "03f18ea74c037a67f47de889354e164551d2441471283a02116a1ab2654eebec" => :el_capitan
    sha256 "1fc9f0dafe564b2ec9d965c3ffc0325bde03fae48d98ab71c4480e3ddf79df15" => :yosemite
  end

  option "without-qcow2", "Do not support qcow2 disk image format"

  depends_on :macos => :yosemite
  depends_on "go" => :build
  depends_on "docker-machine" => :recommended
  if build.with? "qcow2"
    depends_on "opam"
    depends_on "libev"
  end

  def install
    (buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve").install Dir["{*,.git,.gitignore,.gitmodules}"]

    ENV["GOPATH"] = "#{buildpath}/gopath"
    build_root = buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve"
    build_tags = "lib9p"

    cd build_root do
      git_hash = `git rev-parse --short HEAD --quiet`.chomp
      git_hash = "HEAD-#{git_hash}" if build.head?

      if build.with? "qcow2"
        build_tags << " qcow2"
        system "opam", "init", "--no-setup"
        opam_dir = "#{buildpath}/.brew_home/.opam"
        ENV["CAML_LD_LIBRARY_PATH"] = "#{opam_dir}/system/lib/stublibs:/usr/local/lib/ocaml/stublibs"
        ENV["OPAMUTF8MSGS"] = "1"
        ENV["PERL5LIB"] = "#{opam_dir}/system/lib/perl5"
        ENV["OCAML_TOPLEVEL_PATH"] = "#{opam_dir}/system/lib/toplevel"
        ENV.prepend_path "PATH", "#{opam_dir}/system/bin"
        system "opam", "install", "-y", "uri", "qcow-format", "conf-libev"
      end

      go_ldflags = "-w -s -X 'github.com/zchee/docker-machine-driver-xhyve/xhyve.GitCommit=Homebrew#{git_hash}'"
      ENV["GO_LDFLAGS"] = go_ldflags
      ENV["GO_BUILD_TAGS"] = build_tags
      ENV["LIBEV_FILE"] = "#{Formula["libev"].opt_lib}/libev.a"
      system "make", "lib9p"
      system "make", "build"
      bin.install "bin/docker-machine-driver-xhyve"
    end
  end

  def caveats; <<-EOS.undent
    This driver requires superuser privileges to access the hypervisor. To
    enable, execute
        sudo chown root:wheel #{opt_prefix}/bin/docker-machine-driver-xhyve
        sudo chmod u+s #{opt_prefix}/bin/docker-machine-driver-xhyve
    EOS
  end

  test do
    assert_match "xhyve-memory-size",
    shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver xhyve -h")
  end
end
