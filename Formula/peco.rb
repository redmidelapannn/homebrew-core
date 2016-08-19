class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.0.tar.gz"
  sha256 "d04559c04aaf7aab829186e8e977765d8d800ed21a96e0e99c091b90cb7c0f50"
  head "https://github.com/peco/peco.git"

  bottle do
    sha256 "76d7d6a69512059931cb843c8837beab87a5b27c25a5189167108926dc7958f9" => :el_capitan
    sha256 "c89845757c937170989f08d8b7e3a822d334bd054fe2b3eec6f89447721d7138" => :yosemite
    sha256 "43026fef69c27a7b8e156eaa0e8e1c7b80abefc9238b1eacf7e05f18ebeb24ab" => :mavericks
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def go_install(rel = "", options = {})
    ENV["GOPATH"] = buildpath
    using = options[:using]
    rel = Pathname.new(rel)
    proj = Pathname.new(active_spec.url.split("/")[2..4].join("/"))
    proj = proj.dirname/proj.basename(proj.extname)
    dir = buildpath/"src/#{proj}"
    dir.install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src" if using.include? "resources"
    cd dir do
      system "godep", "restore" if using.include? "godep"
      system "glide", "install" if using.include? "glide"
      system "go", "build", "-o", bin/(proj/rel).basename, proj/rel
      prefix.install_metafiles
    end
  end

  def install
    go_install "cmd/peco", :using => "glide"
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
