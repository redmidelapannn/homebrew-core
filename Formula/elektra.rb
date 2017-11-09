class Elektra < Formula
  desc "Configuration Framework"
  homepage "https://libelektra.org"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.8.20.tar.gz"
  sha256 "e9cbc796e175685ccb6221f1dd5ea5c43832f545c40557c32b764ff5d567b312"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    sha256 "9c9c070358993c0996362a39b8e4d3c1d49e63eb60958414edae70cb6e05f37f" => :high_sierra
    sha256 "35cc063989d912f1e2584ab23c61569509adbc73d204530d1690a8d61d6938e5" => :sierra
    sha256 "f4359bf67379f7508a6c041f02e7a2ed3e710278c8161e411f434a3fc57f9e09" => :el_capitan
  end

  option "with-qt", "Build GUI frontend"

  # rubocop: disable Style/ClassVars
  opt = [[:optional], proc {}, []]
  @@plugin_dependencies = {
    "augeas" => [Dependency.new("augeas", *opt)],
    "dbus" => [Dependency.new("dbus", *opt)],
    "gitresolver" => [Dependency.new("libgit2", *opt)],
    "tcl" => [Dependency.new("boost", *opt)],
    "yajl" => [Dependency.new("yajl", *opt)],
    "yamlcpp" => [Dependency.new("yaml-cpp", *opt)],
  }
  option "with-dep-plugins", \
         "Build with additional plugins: " \
         "#{@@plugin_dependencies.keys.join ", "}"

  # Build Dependencies
  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  # Run-Time Dependencies
  @@plugin_dependencies.values.flatten.each do |dependency|
    depends_on dependency
  end

  depends_on "lua" => :optional
  depends_on "swig" if build.with? "lua"
  depends_on "qt" => :optional
  depends_on "discount" if build.with? "qt"

  def install
    cmake_args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
    ]
    bindings = ["cpp"]
    tools = ["kdb", "gen"]
    plugins = ["NODEP"]

    plugins += @@plugin_dependencies.keys if build.with? "dep-plugins"

    if build.with? "lua"
      bindings << "swig_lua"
      plugins << "lua"
    end

    if build.with? "qt"
      tools << "qt-gui"
      cmake_args << "-DCMAKE_PREFIX_PATH=/usr/local/opt/qt5"
    end

    cmake_args += %W[
      -DBINDINGS='#{bindings.join ";"}'
      -DTOOLS='#{tools.join ";"}'
      -DPLUGINS='#{plugins.join ";"}'
    ]

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end

    bash_completion.install "scripts/kdb-bash-completion" => "kdb"
    fish_completion.install "scripts/kdb.fish"
    zsh_completion.install "scripts/kdb_zsh_completion" => "_kdb"
  end

  test do
    kdb = "#{bin}/kdb"
    system kdb, "ls", "/"
    system kdb, "list"
    `#{kdb} list`.split.each { |plugin| system kdb, "check", plugin }
  end
end
