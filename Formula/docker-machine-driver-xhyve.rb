class DockerMachineDriverXhyve < Formula
  desc "Docker Machine driver for xhyve"
  homepage "https://github.com/zchee/docker-machine-driver-xhyve"
  url "https://github.com/zchee/docker-machine-driver-xhyve.git",
    :tag => "v0.3.3",
    :revision => "7d92f74a8b9825e55ee5088b8bfa93b042badc47"

  head "https://github.com/zchee/docker-machine-driver-xhyve.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "dc2c94eb0e3e4dd9df7c23c74619865f7c3317dd947d3cc700205229fc236579" => :high_sierra
    sha256 "ec5212cd107df880fc9cf8af7e41a3660e5186f12a29d1f4c680f3acd15e06df" => :sierra
    sha256 "33108b82a297a6ba834e69dd372083d2557ac65803bd89e6b43b73ec18955832" => :el_capitan
  end

  option "without-qcow2", "Do not support qcow2 disk image format"

  depends_on :macos => :yosemite
  depends_on "go" => :build
  depends_on "docker-machine" => :recommended
  if build.with? "qcow2"
    depends_on "ocaml" => :build
    depends_on "opam" => :build
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

      go_ldflags = "-w -s -X 'github.com/zchee/docker-machine-driver-xhyve/xhyve.GitCommit=Homebrew#{git_hash}'"
      ENV["GO_LDFLAGS"] = go_ldflags
      ENV["GO_BUILD_TAGS"] = build_tags
      ENV["LIBEV_FILE"] = "#{Formula["libev"].opt_lib}/libev.a"

      if build.with? "qcow2"
        build_tags << " qcow2"
        system "opam", "init", "--no-setup"
        opam_dir = "#{buildpath}/.brew_home/.opam"
        ENV["CAML_LD_LIBRARY_PATH"] = "#{opam_dir}/system/lib/stublibs:/usr/local/lib/ocaml/stublibs"
        ENV["OPAMUTF8MSGS"] = "1"
        ENV["PERL5LIB"] = "#{opam_dir}/system/lib/perl5"
        ENV["OCAML_TOPLEVEL_PATH"] = "#{opam_dir}/system/lib/toplevel"
        ENV.prepend_path "PATH", "#{opam_dir}/system/bin"

        inreplace "#{opam_dir}/compilers/4.05.0/4.05.0/4.05.0.comp",
          '["./configure"', '["./configure" "-no-graph"' # Avoid X11

        ENV.deparallelize { system "opam", "switch", "4.05.0" }

        system "opam", "config", "exec", "--",
               "opam", "install", "-y", "uri", "qcow-format", "io-page.1.6.1",
               "conf-libev", "mirage-block-unix>2.3.0", "lwt<3.1.0"

        system "opam", "config", "exec", "--", "make", "lib9p"
        system "opam", "config", "exec", "--", "make", "build"
      else
        system "make", "lib9p"
        system "make", "build"
      end

      bin.install "bin/docker-machine-driver-xhyve"
    end
  end

  def caveats; <<~EOS
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
