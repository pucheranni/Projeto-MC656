package com.MC_656.mobility.service.impl;

import com.MC_656.mobility.model.Veiculo;
import com.MC_656.mobility.repository.VeiculoRepository;
import com.MC_656.mobility.service.VeiculoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class VeiculoServiceImpl implements VeiculoService {

    private final VeiculoRepository veiculoRepository;

    @Autowired
    public VeiculoServiceImpl(VeiculoRepository veiculoRepository) {
        this.veiculoRepository = veiculoRepository;
    }

    @Override
    public Veiculo cadastrarVeiculo(Veiculo veiculo) {
        // TODO: Adicionar validações e lógica de negócio antes de salvar
        return veiculoRepository.save(veiculo);
    }

    @Override
    public Optional<Veiculo> buscarVeiculoPorId(Long id) {
        return veiculoRepository.findById(id);
    }

    @Override
    public List<Veiculo> listarTodosVeiculos() {
        return veiculoRepository.findAll();
    }

    @Override
    public Veiculo atualizarVeiculo(Long id, Veiculo veiculoDetails) {
        // TODO: Adicionar lógica para buscar o veículo existente e atualizá-lo
        // Lançar exceção se o veículo não for encontrado
        Veiculo veiculoExistente = veiculoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Veículo não encontrado com id: " + id)); // Simples exceção por enquanto

        veiculoExistente.setMarca(veiculoDetails.getMarca());
        veiculoExistente.setModelo(veiculoDetails.getModelo());
        veiculoExistente.setAno(veiculoDetails.getAno());
        veiculoExistente.setTipo(veiculoDetails.getTipo());
        veiculoExistente.setDescricao(veiculoDetails.getDescricao());
        // TODO: Adicionar atualização de outros campos e validações

        return veiculoRepository.save(veiculoExistente);
    }

    @Override
    public void deletarVeiculo(Long id) {
        // TODO: Adicionar lógica para verificar se o veículo pode ser deletado
        veiculoRepository.deleteById(id);
    }

    // Implementações de outros métodos de negócio viriam aqui
}
