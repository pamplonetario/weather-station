-- migrate:up
INSERT INTO `estacion` (`id`, `nombre`, `pass_salt`, `pass_hash`) VALUES
(1, 'Default', 'e179e80a35ea598b3a4b659acdf77152ba48e14e', '2e35174428cc47705ba8fb5fc13d7bfc7b1a8370');

-- migrate:down
