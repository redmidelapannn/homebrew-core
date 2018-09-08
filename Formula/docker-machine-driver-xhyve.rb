class DockerMachineDriverXhyve < Formula
  desc "Docker Machine driver for xhyve"
  homepage "https://github.com/zchee/docker-machine-driver-xhyve"
  url "https://github.com/zchee/docker-machine-driver-xhyve.git",
      :tag => "v0.3.3",
      :revision => "7d92f74a8b9825e55ee5088b8bfa93b042badc47"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "7ea1872dea10129ff17a94e73a832876b0dd710d533435840bc7d79a26e8c153" => :high_sierra
    sha256 "5702faf4b0875678f60dabb96f7aca2bc4c84fad447359025a66b99e01b9bc94" => :sierra
    sha256 "f471c39f03f204ad66f9233293ef6691f162caa123a422489b59553b80c76158" => :el_capitan
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
    dir = buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve"
    dir.install Dir["{*,.git,.gitignore,.gitmodules}"]

    ENV["GOPATH"] = "#{buildpath}/gopath"
    build_tags = "lib9p"

    cd dir do
      commit = Utils.popen_read("git rev-parse --short HEAD --quiet").chomp

      ldflags = %W[
        -w -s
        -X github.com/zchee/docker-machine-driver-xhyve/xhyve.GitCommit=Homebrew#{commit}
      ]
      ENV["GO_LDFLAGS"] = ldflags.join(" ")
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

        (buildpath/".brew_home/.opam/config").append_lines <<~EOS
          cflags: "-I#{MacOS.sdk_path}/usr/include"
          cppflags: "-I#{MacOS.sdk_path}/usr/include"
        EOS

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
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    This driver requires superuser privileges to access the hypervisor. To
    enable, execute
      sudo chown root:wheel #{opt_bin}/docker-machine-driver-xhyve
      sudo chmod u+s #{opt_bin}/docker-machine-driver-xhyve
  EOS
  end

  test do
    docker_machine = Formula["docker-machine"].opt_bin/"docker-machine"
    cmd = "#{docker_machine} create --driver xhyve -h"
    assert_match "xhyve-memory-size", shell_output(cmd)
  end
end
