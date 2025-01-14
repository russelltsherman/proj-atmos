build:
	devcontainer up --workspace-folder ./ \
		--dotfiles-repository https://github.com/russelltsherman/dot.git \
		--remove-existing-container

infra: 
	devcontainer exec --workspace-folder ./ /bin/zsh


clean:
	@-find components/terraform -name ".terraform*" -exec rm -rf {} \;
	@-find components/terraform -name "terraform.*" -exec rm -rf {} \;
	@-find components/terraform -name "*.tf.json" -exec rm -rf {} \;
	@-find components/terraform -name "*.tfvars.json" -exec rm -rf {} \;
	@-find components/terraform -name "*.planfile" -exec rm -rf {} \;
