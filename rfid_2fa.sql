create database rfid_2fa;
use rfid_2fa;

create table usuario (
	usu_id int auto_increment primary key,
    usu_nome varchar(255),
    usu_username varchar(255),
    usu_senha varchar(255)
);

create table cartao (
	car_id int auto_increment primary key,
    car_numero varchar(100) unique,
    car_status tinyint,
    car_usu_id int,
	foreign key (car_usu_id) references usuario(usu_id)
);

create table acessos (
	ace_id int auto_increment primary key,
    ace_data timestamp,
    ace_car_id int,
    foreign key (ace_car_id) references cartao(car_id)
);


INSERT INTO usuario (usu_nome, usu_senha) VALUES
('Alice', 'senha123'),
('Bruno', 'senha456'),
('Carla', 'senha789'),
('Diego', 'segredo321'),
('Elisa', 'minhasenha'),
('Felipe', 'pass123'),
('Gabi', 'senhaabc'),
('Henrique', 'senha999'),
('Isabela', 'supersecreto'),
('João', 'joaopass');


INSERT INTO cartao (car_numero, car_status, car_usu_id) VALUES
('A1:B2:C3:D4', 1, 1),
('F6:G7:H8:I9', 1, 2),
('K1:L2:M3:N4', 0, 3),
('P6:Q7:R8:S9', 1, 4),
('U1:V2:W3:X4', 1, 5),
('Z6:A7:B8:C9', 0, 6),
('D1:E2:F3:G4', 1, 7),
('H6:I7:J8:K9', 1, 8),
('L1:M2:N3:O4', 0, 9),
('R6:S7:T8:U9', 1, 10);

select * from cartao;

INSERT INTO acessos (ace_data, ace_car_id) VALUES
(NOW() - INTERVAL 10 DAY, 1),
(NOW() - INTERVAL 8 DAY, 2),
(NOW() - INTERVAL 7 DAY, 3),
(NOW() - INTERVAL 5 DAY, 4),
(NOW() - INTERVAL 3 DAY, 5),
(NOW() - INTERVAL 2 DAY, 6),
(NOW() - INTERVAL 1 DAY, 7),
(NOW() - INTERVAL 12 HOUR, 8),
(NOW() - INTERVAL 6 HOUR, 9),
(NOW(), 10);

select * from usuario 
join cartao on car_usu_id = usu_id
join acessos on ace_car_id = car_id
order by usu_nome;

delimiter $$

create function verifica_acesso_recente(p_usu_id int)
returns boolean
deterministic
begin
    declare v_ultimo_acesso timestamp;

    select max(a.ace_data)
    into v_ultimo_acesso
    from acessos a
    inner join cartao c on c.car_id = a.ace_car_id
    where c.car_usu_id = p_usu_id;

    if v_ultimo_acesso is null then
        return false;
    end if;

    if timestampdiff(second, v_ultimo_acesso, now()) <= 10 then
        return true;
    else
        return false;
    end if;
end$$

delimiter ;

INSERT INTO acessos (ace_data, ace_car_id) VALUES (NOW(), 1);
select verifica_acesso_recente(1);


