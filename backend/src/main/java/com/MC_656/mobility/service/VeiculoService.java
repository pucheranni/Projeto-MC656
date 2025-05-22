package com.MC_656.mobility.service;

import com.MC_656.mobility.model.Veiculo;
import java.util.List;
import java.util.Optional;

public interface VeiculoService {
    Veiculo cadastrarVeiculo(Veiculo veiculo);
    Optional<Veiculo> buscarVeiculoPorId(Long id);
    List<Veiculo> listarTodosVeiculos();
    Veiculo atualizarVeiculo(Long id, Veiculo veiculoDetails);
    void deletarVeiculo(Long id);
    // Outros métodos de negócio podem ser adicionados aqui
    // Ex: List<Veiculo> listarVeiculosPorTipo(String tipo);
    // Ex: List<Veiculo> listarVeiculosDisponiveis();
}
