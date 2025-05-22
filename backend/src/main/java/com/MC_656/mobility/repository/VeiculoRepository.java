package com.MC_656.mobility.repository;

import com.MC_656.mobility.model.Veiculo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List; // Import necessário para List

@Repository
public interface VeiculoRepository extends JpaRepository<Veiculo, Long> {

    // Métodos de busca personalizados podem ser adicionados aqui, por exemplo:
    // List<Veiculo> findByTipo(String tipo);
    // List<Veiculo> findByDisponivelTrue(); 
}
